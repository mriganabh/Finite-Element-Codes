% Author Information
% Author - Mriganabh Boruah
% email id - mboruah@purdue.edu
% Date - November 17th 2020

%% Code Summary
% It is the Main File
% It progresses the state of the system every time step
% It calls various other subroutines like TwoDFEgetinput, plot_model, fecalc, etc.

%%
clear all; clc; close all;                                                  % clear all the existing variables (new start)

% Obtain the input file name from the user & Read Input
[materials, nodes, elems, bcs, nodloads, DynData] = TwoDFEgetinput;
Nel = size(elems,2);
Nnodes = size(nodes,1);
Sim_Endtime = DynData(1);
dt     = DynData(2);
impulse_start = DynData(3);
impulse_end = DynData(4);
gamma  = DynData(5);
beta   = DynData(6);

% Plot to check input
elems = plot_model(elems, nodes);

% User input for plots
prompt = {'Input OK?', 'Plot element stresses?', 'Plot averaged nodal stresses?'};
default = {'y', 'n', 'y'};
inp_by_user = inputdlg(prompt, 'Input for user?', 1, default);

if inp_by_user{1} ~= 'y'
    return;
end

%Timestepping
stress_history = [];
disp_history = [];
disp('Time: ')
time_cur = 0;
disp(time_cur);

% Initial Calculations
[M, K, f] = fecalc(time_cur, elems, nodes, materials, DynData, nodloads);
[d, v, a, doffree, nodalcount] = first_step_computation(bcs, Nnodes, M, K, f);

Nsteps = ceil(Sim_Endtime/dt);
for istep = 1:Nsteps
    
    time_cur = istep*dt;
    disp(time_cur);

    % Global M & K matrices and f vector for this instant of time
    [M, K, f] = fecalc(time_cur, elems, nodes, materials, DynData, nodloads);
    Mtilde = M + beta*dt^2*K;
    
    % Compute acceleration, velocity and displacement
    d(doffree) = d(doffree) + dt*v(doffree) + dt^2*((0.5-beta)*a(doffree));
    v(doffree) = v(doffree) + dt*((1-gamma)*a(doffree));
    a(doffree) = Mtilde(doffree, doffree)\(f(doffree)-K(doffree,:)*d(:));
    d(doffree) = d(doffree) + dt^2*beta*a(doffree);
    v(doffree) = v(doffree) + dt*gamma*a(doffree);
    
    % Compute Stress
    [elems, elemstrs, nodalstrs, nodalcount] = compute_stress(istep, nodalcount, elems, materials, nodes, d); 

    % This loop is for removing the nodes without any contribution &
    % Averaging Nodal Stress
    dof_floating = [];
    for ii = 1:Nnodes
        if nodalcount(ii) == 0
            indexofdof = find(doffree == 2*ii-1);
            dof_floating = [dof_floating; indexofdof; indexofdof+1];
        else
            nodalstrs(ii,:) = nodalstrs(ii,:)/nodalcount(ii);               % Averaging the stresses
        end
    end
    doffree(dof_floating) = [];
    
    % Post-computation : plot displacements & stresseselems(iel).flag = 1;           
    Magnification = 1;
    newnodes = nodes + Magnification*reshape(d,2,Nnodes)';
    
    % Patching new set of elements
    [patchfaces, elemstrs_up] = patch_face_update(elems, elemstrs);
    
    % Plot element stresses
    if inp_by_user{2} == 'y'   
        plot_elemstrs(newnodes, patchfaces, nodalstrs, elemstrs_up, time_cur);
    end
    
    %Plotting stresses WITH nodal averaging 
    if inp_by_user{3} == 'y'
        plot_avg_nodalstrs(istep, newnodes, patchfaces, nodalstrs, time_cur);
    end        
    
end
