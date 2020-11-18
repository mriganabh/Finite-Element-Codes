function [strs] = ThreeDT4elempost(d, nodexyz, Dmat)


% Not needed
% x1 = nodexyz(1,1); y1 = nodexyz(1,2); z1 = nodexyz(1,3);
% x2 = nodexyz(2,1); y2 = nodexyz(2,2); z2 = nodexyz(2,3);
% x3 = nodexyz(3,1); y3 = nodexyz(3,2); z3 = nodexyz(3,3);
% x4 = nodexyz(4,1); y3 = nodexyz(4,2); z4 = nodexyz(4,3);

Vol = 1/6*det([1 1 1 1 ; nodexyz']);
AbsVol = abs(Vol);

% Not needed
% A1 =  det(nodexyz([2 3 4],:));
% A2 = -det(nodexyz([3 4 1],:));
% A3 =  det(nodexyz([4 1 2],:));
% A4 = -det(nodexyz([1 2 3],:));

B1 = -det([ 1 1 1 ; nodexyz([2 3 4],[2 3])']);
B2 =  det([ 1 1 1 ; nodexyz([3 4 1],[2 3])']);
B3 = -det([ 1 1 1 ; nodexyz([4 1 2],[2 3])']);
B4 =  det([ 1 1 1 ; nodexyz([1 2 3],[2 3])']);

C1 =  det([ 1 1 1 ; nodexyz([2 3 4],[1 3])']);
C2 = -det([ 1 1 1 ; nodexyz([3 4 1],[1 3])']);
C3 =  det([ 1 1 1 ; nodexyz([4 1 2],[1 3])']);
C4 = -det([ 1 1 1 ; nodexyz([1 2 3],[1 3])']);

D1 = -det([ 1 1 1 ; nodexyz([2 3 4],[1 2])']);
D2 =  det([ 1 1 1 ; nodexyz([3 4 1],[1 2])']);
D3 = -det([ 1 1 1 ; nodexyz([4 1 2],[1 2])']);
D4 =  det([ 1 1 1 ; nodexyz([1 2 3],[1 2])']);

Bmat = 1/(6*Vol) * ...
    [ B1    0   0       B2  0   0       B3  0   0       B4  0   0 ; ...
       0    C1  0       0   C2  0       0   C3  0       0   C4  0 ; ...
       0    0   D1      0   0   D2      0   0   D3      0   0   D4; ...
      C1    B1  0       C2  B2  0       C3  B3  0       C4  B4  0 ; ...
       0    D1  C1      0   D2  C2      0   D3  C3      0   D4  C4 ; ...
      D1    0   B1      D2  0   B2      D3  0   B3      D4  0   B4 ];      

strs = Dmat*Bmat*d;
strs = [strs'; strs'; strs'; strs']; % Stress at the 4 nodes is the same

