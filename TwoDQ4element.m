%% Author Information
% Author - Mriganabh Boruah
% email id - mboruah@pudue.edu
% Date - November 17th 2020

%% Code Summary
% This subroutine calculates the "element" K, M and f vectors
% Input:
% ------
% xy : 4x2 matrix :      [ x1 y1;
%                          x2 y2;
%                          x3 y3;
%                          x4 y4 ]
% Dmat : 3x3 matrix : Material "Dmat" given
% bxy : 2x1 vector : [ bx;      CONSTANT "body force" for the element
%                      by ]
% edgeloads : ()x3 matrix :     CONSTANT "edge traction" on an edge
%             [ EdgeNumber, tnX, tnY;   (Upto 4 edges - or NO (ZERO) edges)
%               EdgeNumber, tnX, tnY;
%               EdgeNumber, tnX, tnY; ]
% ( Edge1:Node1-Node2, Edge2:Node2-Node3, Edge3:Node3-Node1 ... )

%%

function [Kel, fel, Mel] = TwoDQ4element(xy, Dmat, bxy, edgeloads, dens, ...
                                           time_cur, impulse_start, impulse_end)

Mel = zeros(8,8);
Mel_cons = zeros(8,8);
Kel = zeros(8,8);
fel = zeros(8,1);

% Construct Gauss point locations and weights in 2D for "n1d" points in 1-D
n1d = 1; % 2: Full integration    ;    1: Reduced integration
[xi1 wi] = Gauss1d(n1d); 
xi2 = xi1;                        % xi2 is the same as "eta"
[Xi Eta] = meshgrid(xi1,xi2);
[Wi Wj]  = meshgrid(wi,wi);
Wij = Wi.*Wj;
Xi  = reshape(Xi, 1, size(Xi,1)*size(Xi,2));
Eta = reshape(Eta,1, size(Eta,1)*size(Eta,2));
Wij = reshape(Wij,1, size(Wij,1)*size(Wij,2));

ngp = length(Wij); % Total number of Gauss Points

[Nhat, dNhatdxi, dNhatdeta] = TwoDQ4shape(Xi, Eta);

for ig = 1:ngp % gauss points over the domain of the element
    
    % Get the jacobian and the determinant at the current gauss point
    Jmat = zeros(2);
    for inod = 1:4
        Jmat(1,1) = Jmat(1,1) + dNhatdxi(inod,ig)*xy(inod,1);
        Jmat(1,2) = Jmat(1,2) + dNhatdeta(inod,ig)*xy(inod,1);
        Jmat(2,1) = Jmat(2,1) + dNhatdxi(inod,ig)*xy(inod,2);
        Jmat(2,2) = Jmat(2,2) + dNhatdeta(inod,ig)*xy(inod,2);
    end

    detJ = det(Jmat);
    invJT = inv(Jmat');
    dNdxdy = invJT*[ (dNhatdxi(:,ig))'; (dNhatdeta(:,ig))'];

    B_mat = zeros(3,8);
    N_mat = zeros(2,8);
    for j = 1:4 % 4 nodes
        B_mat(1,2*j-1) = dNdxdy(1,j);
        B_mat(2,2*j)   = dNdxdy(2,j);
        B_mat(3,2*j-1) = dNdxdy(2,j);
        B_mat(3,2*j)   = dNdxdy(1,j);
        
        N_mat(1, 2*j-1) = Nhat(j,ig);
        N_mat(2, 2*j)   = Nhat(j,ig);
    end
    
    % Element Stiffness Matrix & Load Vector
    Kel = Kel + Wij(ig)*B_mat'*Dmat*B_mat*detJ;
    fel = fel + Wij(ig)*N_mat'*bxy*detJ;
    Mel_cons = Mel_cons + dens*Wij(ig)*N_mat'*N_mat*detJ;                        % Consistent mass matrix    
    
end % gauss points

% Lumped Mass matrix
Mel = eye(8).*sum(Mel_cons,2);

% For edge loads
for iedge = 1:size(edgeloads,1)
    switch edgeloads(iedge, 1)
        case 1  % Impulse load
        case 2  % Triangular Pulse between Impulse start & end
            del_t = impulse_end-impulse_start;
            pulse_value = triangularPulse(impulse_start/impulse_end, del_t/2/impulse_end, 1, time_cur);
            edgeloads(:, 3:4) = edgeloads(:, 3:4)*pulse_value;
        case 3  % Sinusoidal Pulse between Impulse start & end
            ncycles = 1;
            del_t = impulse_end-impulse_start;
            pulse_value = sin(2*pi*ncycles*time_cur/del_t);
            edgeloads(:, 3:4) = edgeloads(:, 3:4)*pulse_value;
    end   
    
    switch(edgeloads(iedge,2))
        case 1
            Xi  =  xi1;
            Eta = -ones(1,n1d);
        case 2
            Xi  =  ones(1,n1d);
            Eta =  xi2;
        case 3
            Xi  = -xi1;
            Eta =  ones(1,n1d);
        case 4
            Xi  = -ones(1,n1d);
            Eta = xi2;
    end

    [Nhat, dNhatdxi, dNhatdeta] = TwoDQ4shape(Xi, Eta);

    for ig = 1:n1d % gauss points along each edge

        % Get the jacobian and the determinant at the current gauss point
        Jmat = zeros(2);
        for inod = 1:4
            Jmat(1,1) = Jmat(1,1) + dNhatdxi(inod,ig)*xy(inod,1);
            Jmat(1,2) = Jmat(1,2) + dNhatdeta(inod,ig)*xy(inod,1);
            Jmat(2,1) = Jmat(2,1) + dNhatdxi(inod,ig)*xy(inod,2);
            Jmat(2,2) = Jmat(2,2) + dNhatdeta(inod,ig)*xy(inod,2);
        end

        switch(edgeloads(iedge,2))
            case {1,3}
                Lfac = sqrt( (Jmat(1,1))^2 + (Jmat(2,1))^2 );
            case {2,4}
                Lfac = sqrt( (Jmat(1,2))^2 + (Jmat(2,2))^2 );
        end

        N_mat = zeros(2,8);
        for j = 1:4 % 4 nodes
            N_mat(1, 2*j-1) = Nhat(j,ig);
            N_mat(2, 2*j)   = Nhat(j,ig);
        end

        % Element Load Vector contribution
        fel = fel + wi(ig)*N_mat'*(edgeloads(iedge,3:4))'*Lfac;

    end % gauss points
end
