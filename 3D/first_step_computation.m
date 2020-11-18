%% Author Information
% Author - Mriganabh Boruah
% email id - mboruah@purdue.edu
% Date - November 17th 2020

%% Code Summary
% This function evaluates initial acceleration

%%

function [d, v, a, doffree, nodalcount] = first_step_computation(bcs, Nnodes, M, K, f)

% Apply boundary conditions : ASSUMING ZERO VALUES FOR ALL "SPECDOFS"
d = zeros(3*Nnodes,1);                                              % Initial displacement 
v = zeros(3*Nnodes,1);                                              % Initial velocity
a = zeros(3*Nnodes,1);                                              % Initial acceleration : to be corrected below

doffree = 1:3*Nnodes;                                               % All dofs
dofspec = [];
for ibc = 1:size(bcs,1)
    nodenum = bcs(ibc,1);
    if bcs(ibc,2) == 1
        dofspec = [dofspec; 3*nodenum-2];
        d(3*nodenum-2) = bcs(ibc,5);
    end
    if bcs(ibc,3) == 1
        dofspec = [dofspec; 3*nodenum-1];
        d(3*nodenum-1)   = bcs(ibc,6);
    end
    if bcs(ibc,4) == 1
        dofspec = [dofspec; 3*nodenum];
        d(3*nodenum)   = bcs(ibc,7);
    end
end
doffree(dofspec) = [];                                              % Delete specified dofs from All dofs

% Initial acceleration calculation:
a(doffree) = M(doffree,doffree)\(f(doffree)-K(doffree,:)*d(:));

nodalcount = zeros(Nnodes,1);                                       % For averaging the stresses
       