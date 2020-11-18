function [] = plot_model(nodes, elems)

Nel = size(elems,2);
Nnodes = size(nodes,1);

% Plot to check input
scrsz = get(0,'ScreenSize');
figure('Position',scrsz);
% figure;
xyzmin = min(nodes);
xyzmax = max(nodes);
xyzran = xyzmax-xyzmin;
xyzmin = xyzmin - xyzran;
xyzmax = xyzmax + xyzran;

patchfaces = [];                                                            % All element connectivities
for iel = 1:Nel
    elnodes = elems(iel).conn;
    elems(iel).flag = 1;                                                    % Initiate flag for element deletion
    if elems(iel).typ == 'T4'
        patchfaces = [patchfaces; ...
            elnodes(1) elnodes(2) elnodes(3); ...
            elnodes(2) elnodes(3) elnodes(4); ...
            elnodes(3) elnodes(4) elnodes(1); ...
            elnodes(1) elnodes(2) elnodes(4) ];
    end
end
patch('Vertices',nodes,'Faces',patchfaces, ...
    'FaceVertexCData',zeros(Nnodes,1),'FaceColor','none');
view(3);    hold on;    axis([xyzmin(1) xyzmax(1) xyzmin(2) xyzmax(2) xyzmin(3) xyzmax(3)]);    axis equal; 
xlabel('x'); ylabel('y'); zlabel('z');
%{
% Plot Element numbers
for iel = 1:Nel
    elnodes = elems(iel).conn;
    text(mean(nodes(elnodes,1)), mean(nodes(elnodes,2)), mean(nodes(elnodes,3)), num2str(iel), 'Color','b');
end
% Plot Node numbers
for inod = 1:Nnodes
    text(nodes(inod,1), nodes(inod,2), nodes(inod,3), num2str(inod));
end
%}