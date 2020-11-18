function [M, K, f] = fecalc(nodes, elems, nodloads, materials, time_cur, ...
                            impulse_start, impulse_end)

Nel = size(elems,2);            % Number of elements
Nnodes = size(nodes,1);         % Number of nodes

% Initialize the global stiffness matrix and load vector
M = sparse(3*Nnodes,3*Nnodes);
K = sparse(3*Nnodes,3*Nnodes);
f = zeros(3*Nnodes,1);

% Add contribution of the nodal loads
if (impulse_start <= time_cur && time_cur <= impulse_end)
    for inodloads = 1:size(nodloads,1)
        nodenum = nodloads(inodloads,1);
        switch nodloads(inodloads,2)
            case 1  % Impulse load
                pulse_value = 1;
            case 2  % Triangular Pulse between Impulse start & end
                del_t = impulse_end-impulse_start;
                pulse_value = triangularPulse(impulse_start/impulse_end, del_t/2/impulse_end, 1, time_cur);
            case 3  % Sinusoidal Pulse between Impulse start & end
                ncycles = 1;
                del_t = impulse_end-impulse_start;
                pulse_value = sin(2*pi*ncycles*time_cur/del_t);
        end  
        f(3*nodenum-2) = nodloads(inodloads,3)*pulse_value;
        f(3*nodenum-1) = nodloads(inodloads,4)*pulse_value;
        f(3*nodenum)   = nodloads(inodloads,5)*pulse_value;
    end
end

% Loop over elements to create the global matrices
for iel = 1:Nel
    if elems(iel).flag == 1
        elnodes = elems(iel).conn;
        nodexyz = nodes(elnodes,:);
        elmatnum = elems(iel).matnum;
        [Dmat] = ThreeDFEgetDmat(materials, elmatnum);
        bxyz = elems(iel).bxyz;
        faceloads = elems(iel).faceloads;
        dens = materials(elems(iel).matnum).dens;

        % Get the element stiffness matrix for the current element
        if elems(iel).typ == 'T4'
            [Kel, fel, Mel] = ThreeDT4element(nodexyz, Dmat, bxyz, faceloads, dens, time_cur, ...
                            impulse_start, impulse_end);
        end

        % Assemble the element stiffness matrix into the global stiffness matrix K
        eldofs = kron(elnodes,[3 3 3])+kron([1 1 1 1],[-2 -1 0]);
        eldofs = reshape(eldofs,1, size(eldofs,1)*size(eldofs,2));
        M(eldofs,eldofs) = M(eldofs,eldofs) + Mel;
        K(eldofs,eldofs) = K(eldofs,eldofs) + Kel;
        f(eldofs) = f(eldofs) + fel;
    end
end