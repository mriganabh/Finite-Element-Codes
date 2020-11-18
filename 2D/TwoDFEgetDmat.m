%% Author Information
% Author - Mriganabh Boruah
% email id - mboruah@purdue.edu
% Date - November 17th 2020

%% Code Summary
% This subroutine creates the Dmat matrix (as per Voight Notation)

%%
function [Dmat] = TwoDFEgetDmat(materials, elmatnum)

if materials(elmatnum).typ == 'PlaneStress'
    E = materials(elmatnum).E;
    nu = materials(elmatnum).nu;
    Dmat = E/(1-nu^2)*[1   nu   0 ; ...
                       nu   1   0 ; ...
                        0   0 (1-nu)/2];
elseif materials(elmatnum).typ == 'PlaneStrain'
    E = materials(elmatnum).E;
    nu = materials(elmatnum).nu;
    Dmat = E/((1+nu)*(1-2*nu))* ...
        [1-nu    nu    0 ; ...
           nu  1-nu    0 ; ...
            0     0   (1-2*nu)/2];
end
