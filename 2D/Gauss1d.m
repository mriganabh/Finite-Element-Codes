%% Author Information
% Author - Mriganabh Boruah
% email id - mboruah@purdue.edu
% Date - November 17th 2020

%% Code Summary
% This function returns an array of locations (xi) and the corresponding
% weights (wi) for a given input "n" number of Gauss points

%%
function [xi, wi] = Gauss1d(n)

if n==1
    xi(1) = 0;
    wi(1) = 2;
elseif n==2
    xi(1) = -1/sqrt(3);
    xi(2) =  1/sqrt(3);
    wi(1) = 1;
    wi(2) = 1;
elseif n==3
    xi(1) = -sqrt(3/5);
    xi(2) = 0;
    xi(3) = sqrt(3/5);
    wi(1) = 5/9;
    wi(2) = 8/9;
    wi(3) = 5/9;
elseif n==4
    xi(1) =-.861136311594052575224;
    xi(2) =-.339981043584856264803;
    xi(3) = -xi(2);
    xi(4) = -xi(1);
    wi(1) =.347854845137453857373;
    wi(2) =.652145154862546142627;
    wi(3) = wi(2);
    wi(4) = wi(1);
end
