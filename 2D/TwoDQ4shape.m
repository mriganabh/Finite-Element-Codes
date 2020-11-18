%% Author Information
% Author - Mriganabh Boruah
% email id - mboruah@purdue.edu
% Date - November 17th 2020

%% Code Summary
% This subroutine computes parent shape function and its derivatives depending on
% reduced or full integration
% Input:
% xi  : [ - - - - - - - - - ]: array of some ("n") xi-locations
% eta : [ - - - - - - - - - ]: array of some ("n") eta-locations

% Output:
% Nhat      : 4x(n) matrix of shape functions
%             [ - - - - - - - - - ;           N1
%               - - - - - - - - - ;           N2
%               - - - - - - - - - ;           N3
%               - - - - - - - - -  ]          N4

% dNhatdxi  :4x(n) matrix of shape functions derivatives wrt "xi"
%             [ - - - - - - - - - ;           dN1dxi
%               - - - - - - - - - ;           dN2dxi
%               - - - - - - - - - ;           dN3dxi
%               - - - - - - - - -  ]          dN4dxi

% dNhatdeta :4x(n) matrix of shape functions derivatives wrt "eta"
%             [ - - - - - - - - - ;           dN1deta
%               - - - - - - - - - ;           dN2deta
%               - - - - - - - - - ;           dN3deta
%               - - - - - - - - -  ]          dN4deta

%%

function [Nhat, dNhatdxi, dNhatdeta] = TwoDQ4shape(xi, eta)

xiI  = [ -1,  1,  1,  -1]; % Corner node locations
etaI = [ -1, -1,  1,   1]; 

sizeN = [4 length(xi)]; 

Nhat      = zeros(sizeN);
dNhatdxi  = zeros(sizeN);
dNhatdeta = zeros(sizeN);

% Shape functions & derivatives
for ii = 1:4
    Nhat(ii,:)      = 1/4 * ( 1 + xiI(ii)*xi ) .* ( 1 + etaI(ii)*eta );
    dNhatdxi(ii,:)  = 1/4 * ( xiI(ii) ) * ( 1 + etaI(ii)*eta );
    dNhatdeta(ii,:) = 1/4 * ( 1 + xiI(ii)*xi ) * ( etaI(ii) );
end

% Shape functions

% Nhat(1,:) = (1.0/4.0) * ( 1.0 + xi ) .* ( 1.0 + eta );
% Nhat(2,:) = (1.0/4.0) * ( 1.0 - xi ) .* ( 1.0 + eta );
% Nhat(3,:) = (1.0/4.0) * ( 1.0 - xi ) .* ( 1.0 - eta );
% Nhat(4,:) = (1.0/4.0) * ( 1.0 + xi ) .* ( 1.0 - eta );

% % Derivatives of the shape functions

% dNhatdxi(1,:)   =  (1.0/4.0) * (1.0 + eta );
% dNhatdxi(2,:)   = -(1.0/4.0) * (1.0 + eta );
% dNhatdxi(3,:)   = -(1.0/4.0) * (1.0 - eta );
% dNhatdxi(4,:)   =  (1.0/4.0) * (1.0 - eta );

% dNhatdeta(1,:)  =  (1.0/4.0) * (1.0 + xi  );
% dNhatdeta(2,:)  =  (1.0/4.0) * (1.0 - xi  );
% dNhatdeta(3,:)  = -(1.0/4.0) * (1.0 - xi  );
% dNhatdeta(4,:)  = -(1.0/4.0) * (1.0 + xi  );
