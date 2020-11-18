function [Prin_strs] = ThreeDT4stressinvariants(strs)
%This function calculates the stress invariants and principal stresses
%and returns the principal stresses 

strs_row = strs(1,:);
strs_mat = [strs_row(1) strs_row(4) strs_row(6);...
            strs_row(4) strs_row(2) strs_row(5);...
            strs_row(6) strs_row(5) strs_row(3)];
        
strs_inv1 = trace(strs_mat);

strs_2 = strs_mat*strs_mat;

strs_inv2 = 0.5*(strs_inv1^2 - trace(strs_2));

strs_inv3 = det(strs_mat);

Coeff = [-1 strs_inv1 -strs_inv2 strs_inv3];
Root = roots(Coeff);

P1 = max(Root);
P3 = min(Root);
P2 = strs_inv1 - P1 - P3;
Prin_strs = [P1 P2 P3];
Hydsta_strs = (P1 + P2 + P3)/3;
vonmises_strs = sqrt(((P1-P2)^2 + (P2-P3)^2 +(P3-P1)^2)/2);

[d] = eig(strs_mat);

end

