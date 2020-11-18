%% Author Information
% Author - Mriganabh Boruah
% email id - mboruah@purdue.edu
% Date - November 17th 2020

%% Code Summary
% This subroutine computes the stresses at the integration points, 
% elemental stresses & unaveraged nodal stresses using current displacement
% and removes elements with principal stress > limit specified in input file 

%%
function [elems, elemstrs, nodalstrs, nodalcount] = compute_stress(istep, nodalcount, elems, materials, nodes, d)

Nel = size(elems,2);            % Number of elements
Nnodes = size(nodes,1);         % Number of nodes

% Element stresses
elemstrs = zeros(Nel,6);
nodalstrs = zeros(Nnodes,6); 
for iel = 1:Nel
    if elems(iel).flag == 1
        elnodes = elems(iel).conn;
        nodexyz = nodes(elnodes,:);
        elmatnum = elems(iel).matnum;
        [Dmat] = ThreeDFEgetDmat(materials, elmatnum);
        eldofs = kron(elnodes,[3 3 3])+kron([1 1 1 1],[-2 -1 0]);
        if elems(iel).typ == 'T4'
            [strs] = ThreeDT4elempost(d(eldofs), nodexyz, Dmat);
        end

        [Prin_strs] = ThreeDT4stressinvariants(strs);                   %Principal Stresses

        if (max(Prin_strs) < materials(elmatnum).strs_lim)              %This loop decides if element is to be deleted
            elemstrs(4*iel-3:4*iel,:) = strs;
            nodalstrs(elnodes,:) = nodalstrs(elnodes,:) + strs;
            if istep == 1
                nodalcount(elnodes) = nodalcount(elnodes)+1;
            end
        else
            elems(iel).flag = 0;
            if istep ~= 1
                nodalcount(elnodes) = nodalcount(elnodes)-1;
            end 
        end
    end
end