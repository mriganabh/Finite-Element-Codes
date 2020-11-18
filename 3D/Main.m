% FE code for a 3D Problem 

clear all; clc; close all; % clear all the existing variables (new start)

% Obtain the input file name from the user & Read Input
inpfilename = uigetfile('*.txt','Select the input file'); 
[materials, nodes, elems, bcs, nodloads, DynData] = ThreeDFEgetinput(inpfilename);
Nel = size(elems,2);            % Number of elements
Nnodes = size(nodes,1);         % Number of nodes
t0 = DynData(1);                % Simulation start time
tF = DynData(2);                % Simulation end time
dt = DynData(3);                % Time-step
impulse_start = DynData(4);     % Impulse start time
impulse_end = DynData(5);       % Impulse end time
gamma  = DynData(6);            % Newmark gamma
beta   = DynData(7);            % Newmark beta

% Plot input model
plot_model(nodes, elems);

% User input for plots
prompt = {'Input OK?', 'Plot element stresses?', 'Plot averaged nodal stresses?'};
default = {'y', 'n', 'y'};
inp_by_user = inputdlg(prompt, 'Input for user?', 1, default);

if inp_by_user{1} ~= 'y'
    return;
end

% Initial Acceleration Computation
time_cur = t0;
disp('Time: ')
disp(time_cur);
[M, K, f] = fecalc(nodes, elems, nodloads, materials, time_cur, ...
                            impulse_start, impulse_end);
[d, v, a, doffree, nodalcount] = first_step_computation(bcs, Nnodes, M, K, f);

% Timestepping
Nsteps = ceil(tF/dt);
for istep = 1:Nsteps
    
    time_cur = time_cur + dt;
    disp(time_cur)    
    
    % Global M & K matrices and f vector for this instant of time
    [M, K, f] = fecalc(nodes, elems, nodloads, materials, time_cur, ...
                            impulse_start, impulse_end);
    Mtilde = M + beta*dt^2*K;

    % Compute acceleration, velocity and displacement
    d(doffree) = d(doffree) + dt*v(doffree) + dt^2 * ((0.5-beta)*a(doffree));
    v(doffree) = v(doffree) + dt*((1-gamma)*a(doffree));
    a(doffree) = Mtilde(doffree,doffree)\(f(doffree)-K(doffree,:)*d(:));
    d(doffree) = d(doffree) + dt^2*beta*a(doffree);
    v(doffree) = v(doffree) + dt*gamma*a(doffree);
    
    % Compute Stress
    [elems, elemstrs, nodalstrs, nodalcount] = compute_stress(istep, nodalcount, elems, materials, nodes, d);
    
    %This loop is for removing the nodes without any contribution
    dof_floating = [];
    for ii = 1:Nnodes
        if nodalcount(ii) == 0
            indexofdof = find(doffree == 3*ii-2);
            dof_floating = [dof_floating; indexofdof; indexofdof+1; indexofdof+2];
        else
            nodalstrs(ii,:) = nodalstrs(ii,:)/nodalcount(ii);               % Averaging the stresses
        end
    end
    doffree(dof_floating) = [];
    
    % Post-computation : plot displacements & stresses
    Magnification = 1;
    newnodes = nodes + Magnification*reshape(d,3,Nnodes)';
    
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
