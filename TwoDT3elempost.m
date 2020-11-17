function [strs, strn] = TwoDT3elempost(d, nodexyz, Dmat)

x1 = nodexyz(1,1); y1 = nodexyz(1,2);
x2 = nodexyz(2,1); y2 = nodexyz(2,2);
x3 = nodexyz(3,1); y3 = nodexyz(3,2);

Area = 1/2 * det([1 1 1 ; nodexyz']);

A1 = x2*y3 - x3*y2;    B1 = y2 - y3;    C1 = x3 -x2;
A2 = x3*y1 - x1*y3;    B2 = y3 - y1;    C2 = x1 -x3;
A3 = x1*y2 - x2*y1;    B3 = y1 - y2;    C3 = x2 -x1;

Bmat = 1/(2*Area) * ...
    [ B1  0   B2  0   B3  0 ;
       0 C1    0 C2    0 C3 ;
      C1 B1   C2 B2   C3 B3 ];      

strs = Dmat*Bmat*d;
strn = Bmat*d;
strs = [strs'; strs'; strs']; % Stress at the 3 nodes is the same
strn = [strn'; strn'; strn'];

