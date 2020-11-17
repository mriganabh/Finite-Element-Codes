% This function plots element stresses

function [] = plot_elemstrs(newnodes, patchfaces, nodalstrs, elemstrs_up, time_cur)

% Plotting stresses first without nodal averaging 
figure(1);
cla; clf;
%subplot(3,1,1); 
title(sprintf('Stresses Sxx - NOT averaged (Time = %0.8f)', time_cur));
patch('Vertices',newnodes,'Faces',patchfaces, ... 
    'FaceVertexCData',elemstrs_up(:,1),'FaceColor','flat');
caxis([min(nodalstrs(:,1))*0.9 max(nodalstrs(:,1))*1.1]);    
axis equal;
colorbar;
colormap(jet);

%{
subplot(3,1,2);
title(sprintf('Stresses Syy - NOT averaged (Time = %0.8f)', time_cur)); axis equal;
patch('Vertices',newnodes,'Faces',patchfaces, ...
   'FaceVertexCData',elemstrs_up(:,2),'FaceColor','flat');
 caxis([min(nodalstrs(:,2))*0.9 max(nodalstrs(:,2))*1.1]);    
colorbar;
colormap(jet);

subplot(3,1,3); 
title(sprintf('Stresses Sxy - NOT averaged (Time = %0.8f)', time_cur)); axis equal;
patch('Vertices',newnodes,'Faces',patchfaces, ...
    'FaceVertexCData',elemstrs_up(:,3),'FaceColor','flat');
 caxis([min(nodalstrs(:,3))*0.9 max(nodalstrs(:,3))*1.1]);    
colorbar;
colormap(jet);
%}