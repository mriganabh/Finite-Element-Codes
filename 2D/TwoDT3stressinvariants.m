%% Author Information 
% Author - Mriganabh Boruah
% email id - mboruah@purdue.edu
% Date - November 17th 2020

%% Code Summary
% This function calculates the stress invariants and principal stresses
% and returns the principal stresses 

%%

function [Prin_strs] = TwoDT3stressinvariants(strs)

strs_row = strs(1,:);
strs_mat = [strs_row(1) strs_row(3);...
            strs_row(3) strs_row(2)];

[v,d] = eig(strs_mat);

Prin_strs = [d(1,1) d(2,2)];

% Assuming plane stress criterion
vonmises_strs = sqrt( Prin_strs(1)^2 - Prin_strs(1)*Prin_strs(2) + ...
                      Prin_strs(2)^2);  
end

