%% Author Information
% Author - Mriganabh Boruah
% email id - mboruah@purdue.edu
% Date - November 17th 2020

%% Code Summary
% This subroutine determines the connectivity of the active elements at 
% the specified instant of time (or elements which are not deleted)

%%
function [patchfaces, elemstrs_up] = patch_face_update(elems, elemstrs)
Nel = size(elems,2);            % Number of elements

%Patching new set of elements
patchfaces = [];
elemstrs_up = [];
for iel = 1:Nel
    if elems(iel).flag == 1
        elnodes = elems(iel).conn;
        if elems(iel).typ == 'T4'
            patchfaces = [patchfaces; ...
                elnodes(1) elnodes(2) elnodes(3); ...
                elnodes(2) elnodes(3) elnodes(4); ...
                elnodes(3) elnodes(4) elnodes(1); ...
                elnodes(1) elnodes(2) elnodes(4) ];            
            elemstrs_up = [elemstrs_up; elemstrs(iel,:)];
        end
    end
end