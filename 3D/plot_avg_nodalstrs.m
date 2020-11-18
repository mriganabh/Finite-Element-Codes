%% Author Information
% Author - Mriganabh Boruah
% email id - mboruah@purdue.edu
% Date - November 17th 2020

%% Code Summary
% This subroutine plots the averaged nodal stresses

%%

function [] = plot_avg_nodalstrs(istep, newnodes, patchfaces, nodalstrs, time_cur)

xyzmin = min(newnodes);
xyzmax = max(newnodes);
xyzran = xyzmax-xyzmin;
xyzmin = xyzmin - xyzran;
xyzmax = xyzmax + xyzran;

if mod(istep,1)==0    
    % Plotting stresses WITH nodal averaging 
    % subplot(3,2,1); 
    figure(2);
    view(3); cla;
    title(sprintf('Stresses Sxx - averaged (Time = %0.8f)', time_cur));   
    axis equal;
    patch('Vertices',newnodes,'Faces',patchfaces, ...
        'FaceVertexCData',nodalstrs(:,1),'FaceColor','interp');
    xlabel('x'); ylabel('y'); zlabel('z');
    axis([xyzmin(1) xyzmax(1) xyzmin(2) xyzmax(2) xyzmin(3) xyzmax(3)]);
    colorbar;
    colormap(jet);

    %{
    subplot(3,2,2); cla; title('Stresses Syy - NOT Averaged'); axis equal;
    patch('Vertices',newnodes,'Faces',patchfaces, ...
        'FaceVertexCData',nodalstrs(:,2),'FaceColor','interp');
    xlabel('x'); ylabel('y'); zlabel('z'); colorbar;
    axis([xyzmin(1) xyzmax(1) xyzmin(2) xyzmax(2) xyzmin(3) xyzmax(3)]);
    text(xyzmax(1)-0.5*xyzran(1), xyzmax(2)-0.5*xyzran(2), xyzmax(3)-0.5*xyzran(3), ['Time = ' num2str(time)]);
    
    subplot(3,2,3); cla; title('Stresses Szz - NOT Averaged'); axis equal;
    patch('Vertices',newnodes,'Faces',patchfaces, ...
         'FaceVertexCData',nodalstrs(:,3),'FaceColor','interp');
    xlabel('x'); ylabel('y'); zlabel('z'); colorbar;
    axis([xyzmin(1) xyzmax(1) xyzmin(2) xyzmax(2) xyzmin(3) xyzmax(3)]);
    text(xyzmax(1)-0.5*xyzran(1), xyzmax(2)-0.5*xyzran(2), xyzmax(3)-0.5*xyzran(3), ['Time = ' num2str(time)]);
     
    subplot(3,2,4); cla; title('Stresses Sxy - NOT Averaged'); axis equal;
    patch('Vertices',newnodes,'Faces',patchfaces, ...
         'FaceVertexCData',nodalstrs(:,4),'FaceColor','interp');
    xlabel('x'); ylabel('y'); zlabel('z'); colorbar;
    axis([xyzmin(1) xyzmax(1) xyzmin(2) xyzmax(2) xyzmin(3) xyzmax(3)]);
    text(xyzmax(1)-0.5*xyzran(1), xyzmax(2)-0.5*xyzran(2), xyzmax(3)-0.5*xyzran(3), ['Time = ' num2str(time)]);
    
    subplot(3,2,5); cla; title('Stresses Syz - NOT Averaged'); axis equal;
    patch('Vertices',newnodes,'Faces',patchfaces, ...
        'FaceVertexCData',nodalstrs(:,5),'FaceColor','interp');
    xlabel('x'); ylabel('y'); zlabel('z'); colorbar;
    axis([xyzmin(1) xyzmax(1) xyzmin(2) xyzmax(2) xyzmin(3) xyzmax(3)]);
    text(xyzmax(1)-0.5*xyzran(1), xyzmax(2)-0.5*xyzran(2), xyzmax(3)-0.5*xyzran(3), ['Time = ' num2str(time)]);
    
    subplot(3,2,6); cla; title('Stresses Szx - NOT Averaged'); axis equal;
    patch('Vertices',newnodes,'Faces',patchfaces, ...
        'FaceVertexCData',nodalstrs(:,6),'FaceColor','interp');
    xlabel('x'); ylabel('y'); zlabel('z'); colorbar;
    axis([xyzmin(1) xyzmax(1) xyzmin(2) xyzmax(2) xyzmin(3) xyzmax(3)]);
    text(xyzmax(1)-0.5*xyzran(1), xyzmax(2)-0.5*xyzran(2),
    xyzmax(3)-0.5*xyzran(3), ['Time = ' num2str(time)]);];
    %}
end