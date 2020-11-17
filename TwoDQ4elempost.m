%% Author Information
% Author - Mriganabh Boruah
% email id - mboruah@pudue.edu
% Date - November 17th 2020

%% Code Summary
% This subroutine evaluates the stresses at each integration point for the element

%%

function [strs] = TwoDQ4elempost(d, xy, Dmat)

n1d = 1; % 2: Full integration    ;    1: Reduced integration (Barlow point)
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

strs = [];
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
    for j = 1:4 % 4 nodes
        B_mat(1,2*j-1) = dNdxdy(1,j);
        B_mat(2,2*j)   = dNdxdy(2,j);
        B_mat(3,2*j-1) = dNdxdy(2,j);
        B_mat(3,2*j)   = dNdxdy(1,j);
    end
    
    strs = [strs Dmat*B_mat*d];
    
end % gauss points

if n1d==1
    strs = [strs strs strs strs]; % Assuming the same stress at the 4 nodes
elseif n1d==2
    strs  = [strs(:,[1,3,4,2])];
end

strs = strs'; % 4x3 (nodes x s11-s22-s12) components
