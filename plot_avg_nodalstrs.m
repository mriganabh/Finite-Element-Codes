%% Author Information
% Author - Mriganabh Boruah
% email id - mboruah@pudue.edu
% Date - November 17th 2020

%% Code Summary
% This subroutine plots the averaged nodal stresses
%%

function [] = plot_avg_nodalstrs(istep, newnodes, patchfaces, nodalstrs, time_cur)

if mod(istep,1)==0
    figure(2);
    %subplot(3,1,1); 
    cla; 
    title(sprintf('Stresses Sxx - averaged (Time = %0.8f)', time_cur));     
    patch('Vertices',newnodes,'Faces',patchfaces, ...
        'FaceVertexCData',nodalstrs(:,1),'FaceColor','interp');
    %xlim([-10 65]);
    %ylim([-5 15]);
    caxis([min(nodalstrs(:,1))*0.9 max(nodalstrs(:,1))*1.1]); 
    
    axis equal;
    colorbar;
    colormap(jet);
    
    %{  
    subplot(3,1,2); cla; title('Stresses Syy - Averaged'); axis equal;
    patch('Vertices',newnodes,'Faces',patchfaces, ...
        'FaceVertexCData',nodalstrs(:,2),'FaceColor','interp');
    xlim([-10 65]);
    ylim([-5 15]);
    % caxis([min(nodalstrs(:,2))*0.9 max(nodalstrs(:,2))*1.1]);    
    colorbar;

    subplot(3,1,3); cla; title('Stresses Sxy - Averaged'); axis equal;
    patch('Vertices',newnodes,'Faces',patchfaces, ...
        'FaceVertexCData',nodalstrs(:,3),'FaceColor','interp');
    xlim([-10 65]);
    ylim([-5 15]);
    % caxis([min(nodalstrs(:,3))*0.9 max(nodalstrs(:,3))*1.1]);    
    colorbar;
    %}

end

