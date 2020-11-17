%% Author Information
% Author - Mriganabh Boruah
% email id - mboruah@pudue.edu
% Date - November 17th 2020

%% Code Summary
% This subroutine evaluates the global Mass & Stiffness matrices
% and global force vector at the specified instant of time "time_cur"

%%

function [M, K, f] = fecalc(time_cur, elems, nodes, materials, DynData, nodloads)

impulse_start = DynData(3);
impulse_end = DynData(4);

Nnodes = size(nodes,1);
M = sparse(2*Nnodes, 2*Nnodes);
K = sparse(2*Nnodes, 2*Nnodes);
f = zeros(2*Nnodes,1);

% Add any global nodal loads 
if (impulse_start <= time_cur && time_cur <= impulse_end)
    for inodloads = 1:size(nodloads,1)
        nodenum = nodloads(inodloads,1);
        switch nodloads(inodloads,2)
            case 1  % Impulse load
                f(2*nodenum-1) = nodloads(inodloads,3);
                f(2*nodenum)   = nodloads(inodloads,4);
            case 2  % Triangular Pulse between Impulse start & end
                del_t = impulse_end-impulse_start;
                pulse_value = triangularPulse(impulse_start/impulse_end, del_t/2/impulse_end, 1, time_cur);
                f(2*nodenum-1) = nodloads(inodloads,3)*pulse_value;
                f(2*nodenum)   = nodloads(inodloads,4)*pulse_value;
            case 3  % Sinusoidal Pulse between Impulse start & end
                ncycles = 1;
                del_t = impulse_end-impulse_start;
                pulse_value = sin(2*pi*ncycles*time_cur/del_t);
                f(2*nodenum-1) = nodloads(inodloads,3)*pulse_value;
                f(2*nodenum)   = nodloads(inodloads,4)*pulse_value;
        end    
    end
end

% Updating Global K, M, f matrix at every time-step
for iel = 1:size(elems,2)
    if elems(iel).flag == 1
        elnodes = elems(iel).conn;
        nodexyz = nodes(elnodes,:);
        elmatnum = elems(iel).matnum;
        [Dmat] = TwoDFEgetDmat(materials, elmatnum);
        bxy = elems(iel).bxy;        
        dens = materials(elmatnum).dens;
        if (impulse_start <= time_cur && time_cur <= impulse_end)   
            edgeloads = elems(iel).edgeloads;             
        else
            edgeloads = [];
        end

        % Get the element stiffness matrix for the current element
        if elems(iel).typ == 'T3'
            [Kel, fel, Mel] = TwoDT3element(nodexyz, Dmat, bxy, edgeloads, ...
                                            dens, time_cur, impulse_start, impulse_end);
        elseif elems(iel).typ == 'T6'
            [Kel, fel] = TwoDT6element(nodexyz, Dmat, bxy, edgeloads);
        elseif elems(iel).typ == 'Q4'
            [Kel, fel, Mel] = TwoDQ4element(nodexyz, Dmat, bxy, edgeloads, ...
                                            dens, time_cur, impulse_start, impulse_end);
        elseif elems(iel).typ == 'Q8'
            [Kel, fel] = TwoDQ8element(nodexyz, Dmat, bxy, edgeloads);
        end

        % Assemble the element stiffness matrix into the global stiffness matrix K
        eldofs = [2*elnodes-1 ; 2*elnodes];
        eldofs = reshape(eldofs,1, size(eldofs,1)*size(eldofs,2));
        M(eldofs,eldofs) = M(eldofs,eldofs) + Mel;
        K(eldofs,eldofs) = K(eldofs,eldofs) + Kel;
        f(eldofs) = f(eldofs) + fel;
    end
end
