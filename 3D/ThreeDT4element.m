function [Kel, fel, Mel] = ThreeDT4element(nodexyz, Dmat, bxyz, faceloads, dens, time_cur, ...
                            impulse_start, impulse_end)

% This subroutine calculates the "element" K and f vectors 
% Input:
% ------
% nodexyz : 4x3 matrix : [ x1 y1 z1;
%                          x2 y2 z2;
%                          x3 y3 z3;
%                          x4 y4 z4]
% Dmat : 6x6 matrix : Material "Dmat" given 
% bxy : 3x1 vector : [ bx;      CONSTANT "body force" for the element
%                      by 
%                      bz ]
% faceloads : ()x4 matrix :     CONSTANT "face traction" on a face
%             [ FaceNumber, tnX, tnY, tnZ;   (Upto 4 faces - or NO (ZERO) faces)
%               FaceNumber, tnX, tnY, tnZ; 
%               FaceNumber, tnX, tnY, tnZ; 
%               FaceNumber, tnX, tnY, tnZ; ] 
% FaceNumber (1:1-2-3, 2:2-3-4, 3:3-4-1, 4:1-2-4)

% Not needed
% Kel = zeros(12,12);
% fel = zeros(12,1);

% Not needed
% x1 = nodexyz(1,1); y1 = nodexyz(1,2); z1 = nodexyz(1,3);
% x2 = nodexyz(2,1); y2 = nodexyz(2,2); z2 = nodexyz(2,3);
% x3 = nodexyz(3,1); y3 = nodexyz(3,2); z3 = nodexyz(3,3);
% x4 = nodexyz(4,1); y3 = nodexyz(4,2); z4 = nodexyz(4,3);

Vol = 1/6*det([1 1 1 1 ; nodexyz']);
AbsVol = abs(Vol);

A1 =  det(nodexyz([2 3 4],:));
A2 = -det(nodexyz([3 4 1],:));
A3 =  det(nodexyz([4 1 2],:));
A4 = -det(nodexyz([1 2 3],:));

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

Kel = AbsVol * (Bmat')*Dmat*Bmat;  

fel = AbsVol/4*[ bxyz ; bxyz ; bxyz ; bxyz ];

% FaceTractions
% FaceNumber (1:1-2-3, 2:2-3-4, 3:3-4-1, 4:1-2-4)
if (impulse_start <= time_cur && time_cur <= impulse_end)
    for iface = 1:size(faceloads,1)
        facenum = faceloads(iface,1);
        switch (facenum)
            case 1
                n1 = nodexyz(1,:); n2 = nodexyz(2,:); n3 = nodexyz(3,:);
                facedofs = 1:9;
            case 2
                n1 = nodexyz(2,:); n2 = nodexyz(3,:); n3 = nodexyz(4,:);
                facedofs = 4:12;
            case 3
                n1 = nodexyz(3,:); n2 = nodexyz(4,:); n3 = nodexyz(1,:);
                facedofs = [7:12 1:3];
            case 4
                n1 = nodexyz(1,:); n2 = nodexyz(2,:); n3 = nodexyz(4,:);
                facedofs = [1:6 10:12];
        end
        facearea = 0.5*norm(cross(n2-n1,n3-n1));
        switch faceloads(iface,2)
            case 1  % Impulse load
                pulse_value = 1;
            case 2  % Triangular Pulse between Impulse start & end
                del_t = impulse_end-impulse_start;
                pulse_value = triangularPulse(impulse_start/impulse_end, del_t/2/impulse_end, 1, time_cur);
            case 3  % Sinusoidal Pulse between Impulse start & end
                ncycles = 1;
                del_t = impulse_end-impulse_start;
                pulse_value = sin(2*pi*ncycles*time_cur/del_t);
        end  
        fel(facedofs) = fel(facedofs) + facearea/3*[kron([1 1 1],faceloads(iface,3:5)*pulse_value)]';
    end
end

% Calculate Mass matrix
if (nargout==3)
    Mel_cons = 6/120*dens*AbsVol*(kron(ones(4)+eye(4),eye(3)));
    Mel = diag(eye(12)*sum(Mel_cons,2));
end

