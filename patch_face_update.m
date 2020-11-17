% This function patches the new set of elements w/o the removed elements
% and patches the elements in domain B

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
    