%% Author Information
% Author - Mriganabh Boruah
% email id - mboruah@purdue.edu
% Date - November 17th 2020

%% Code Summary
% This function plots the input model, node numbers & element numbers

%%

function [elems]=plot_model(elems, nodes)

% Plot to check input
scrsz = get(0,'ScreenSize');
figure('Position',scrsz);
patchfaces = nan(size(elems,2),9);                                                    % All element connectivities
for iel = 1:size(elems,2)
    elems(iel).flag = 1;                                                    % Initiate flag for element deletion
    elnodes = elems(iel).conn;
    if elems(iel).typ == 'T3'
        patchfaces(iel,1:length(elnodes)) = elnodes;
    elseif elems(iel).typ == 'T6'
        patchfaces(iel,1:length(elnodes)) = [elnodes(1) elnodes(4) ...
            elnodes(2) elnodes(5) elnodes(3) elnodes(6) ] ;
    elseif elems(iel).typ == 'Q4'
        patchfaces(iel,1:length(elnodes)) = elnodes;
    elseif elems(iel).typ == 'Q8'
        patchfaces(iel,1:length(elnodes)) = [elnodes(1) elnodes(5) ...
            elnodes(2) elnodes(6) elnodes(3) elnodes(7) elnodes(4) ...
            elnodes(8) ] ;
    end
end
patch('Vertices',nodes,'Faces',patchfaces, ...
    'FaceVertexCData',zeros(size(nodes,1),1),'FaceColor','flat');
axis equal;     hold on;
% Plot Element numbers
for iel = 1:size(elems,2)
    elnodes = elems(iel).conn;
    text(mean(nodes(elnodes,1)), mean(nodes(elnodes,2)),num2str(iel));
end

% Plot Node numbers
for inod = 1:size(nodes,1)
    text(nodes(inod,1), nodes(inod,2),num2str(inod));
end
