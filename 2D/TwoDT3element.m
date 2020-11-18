%% fAuthor Information
% Author - Mriganabh Boruah
% email id - mboruah@pudue.edu
% Date - November 17th 2020

%% Code Summary
% This subroutine calculates the "element" K, M matrices and f vectors 
% Input:
% ------
% nodexyz : 3x2 matrix : [ x1 y1;
%                          x2 y2;
%                          x3 y3 ]
% Dmat : 3x3 matrix : Material "Dmat" given 
% bxy : 2x1 vector : [ bx;      CONSTANT "body force" for the element
%                      by ]
% edgeloads : ()x3 matrix :     CONSTANT "edge traction" on an edge
%             [ EdgeNumber, tnX, tnY;   (Upto 3 edges - or NO (ZERO) edges)
%               EdgeNumber, tnX, tnY; 
%               EdgeNumber, tnX, tnY; ] 
% ( Edge1:Node1-Node2, Edge2:Node2-Node3, Edge3:Node3-Node1 )


function [Kel, fel, Mel] = TwoDT3element(nodexyz, Dmat, bxy, edgeloads, ...
                                         dens, time_cur, impulse_start, impulse_end)

Kel = zeros(6,6);
fel = zeros(6,1);

x1 = nodexyz(1,1); y1 = nodexyz(1,2);
x2 = nodexyz(2,1); y2 = nodexyz(2,2);
x3 = nodexyz(3,1); y3 = nodexyz(3,2);

Area = 1/2*det([1 1 1 ; nodexyz']);
AbsArea = abs(Area);

A1 = x2*y3 - x3*y2;    B1 = y2 - y3;    C1 = x3 -x2;
A2 = x3*y1 - x1*y3;    B2 = y3 - y1;    C2 = x1 -x3;
A3 = x1*y2 - x2*y1;    B3 = y1 - y2;    C3 = x2 -x1;

Bmat = 1/(2*Area) * ...
    [ B1  0   B2  0   B3  0 ;
       0 C1    0 C2    0 C3 ;
      C1 B1   C2 B2   C3 B3 ];      

Kel = AbsArea * (Bmat')*Dmat*Bmat;  

fel = AbsArea/3*[ bxy ; bxy ; bxy ];

if (impulse_start <= time_cur && time_cur <= impulse_end)
   numedgeloads = size(edgeloads,1);
   for ii = 1:numedgeloads
      switch edgeloads(ii, 2)
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
      edgenum = edgeloads(ii,1);
      txy = edgeloads(ii,3:4)'*pulse_value;
      edgenode1 = edgenum;
      edgenode2 = mod(edgenum,3)+1; % Edge1:1-2, Edge2:2-3, Edge3:3-1
      edgedofs = [2*edgenode1-1 2*edgenode1 2*edgenode2-1 2*edgenode2];
      edgelength = sqrt( (nodexyz(edgenode2,1)-nodexyz(edgenode1,1))^2 ...
                      +  (nodexyz(edgenode2,2)-nodexyz(edgenode1,2))^2 );
      fel(edgedofs) = fel(edgedofs) + edgelength/2*[ txy ; txy ];
  end
end


% Consistent Mass Matrix
Mel_cons = 1/12*dens*AbsArea*(kron(ones(3)+eye(3),eye(2)));
%Mel = Mel_cons;
% Lumped Mass Matrix (as per ABAQUS Theory Manual 2.4.1)
Mel = diag(eye(6)*sum(Mel_cons,2));
  


