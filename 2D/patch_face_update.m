%% Author Information
% Author - Mriganabh Boruah
% email id - mboruah@purdue.edu
% Date - November 17th 2020

%% Code Summary
% This subroutine determines the connectivity of the active elements at 
% the specified instant of time (or elements which are not deleted)

%%

function [patchfaces, elemstrs_up] = patch_face_update(elems, elemstrs)

patchfaces = [];
elemstrs_up = [];
for iel = 1:size(elems,2)
    elnodes = elems(iel).conn;
    if elems(iel).flag == 1            
        if elems(iel).typ == 'T3'
            patchfaces = [patchfaces; elnodes];
            elemstrs_up = [elemstrs_up; elemstrs(iel,:)];
        elseif elems(iel).typ == 'Q4'
            patchfaces = [patchfaces; elnodes];
            elemstrs_up = [elemstrs_up; elemstrs(iel,:)];
        end
    end
end
    
