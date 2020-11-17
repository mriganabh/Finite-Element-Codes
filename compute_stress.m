%% Author Information
% Author - Mriganabh Boruah
% email id - mboruah@pudue.edu
% Date - November 17th 2020

%% Code Summary
% This subroutine computes the stresses at the integration points, 
% elemental stresses & unaveraged nodal stresses using current displacement
% and removes elements with principal stress > limit specified in input file 

%%
function [elems, elemstrs, nodalstrs, nodalcount] = compute_stress(istep, nodalcount, elems, materials, nodes, d) 

% Element stresses
elemstrs = zeros(size(elems,2),3);
nodalstrs = zeros(size(nodes,1),3); 
for iel = 1:size(elems,2)
    if elems(iel).flag == 1
        elnodes = elems(iel).conn;
        nodexyz = nodes(elnodes,:);
        elmatnum = elems(iel).matnum;
        [Dmat] = TwoDFEgetDmat(materials, elmatnum);
        eldofs = [2*elnodes-1 ; 2*elnodes];
        eldofs = reshape(eldofs,1, size(eldofs,1)*size(eldofs,2));
        if elems(iel).typ == 'T3'
            [strs, strn] = TwoDT3elempost(d(eldofs), nodexyz, Dmat);
            [Prin_strs] = TwoDT3stressinvariants(strs);                     % Principal Stresses
        elseif elems(iel).typ == 'T6'
            [strs] = TwoDT6elempost(d(eldofs), nodexyz, Dmat);
        elseif elems(iel).typ == 'Q4'
            [strs] = TwoDQ4elempost(d(eldofs), nodexyz, Dmat);
            [Prin_strs] = TwoDQ4stressinvariants(strs);                     % Principal Stresses
        elseif elems(iel).typ == 'Q8'
            [strs] = TwoDQ8elempost(d(eldofs), nodexyz, Dmat);
        end

        if (max(Prin_strs) < materials(elmatnum).strs_lim)                  % This loop decides if element is to be deleted 
            elemstrs(iel,:) = mean(strs);
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
