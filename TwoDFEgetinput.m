function [materials, nodes, elems, bcs, nodloads, DynData] = TwoDFEgetinput

% Read the input file
[probname, dirname] = uigetfile('./*.txt','Input File Name'); 
fid = fopen([dirname probname],'r');

% Read the Material Data
fgetl(fid); % This reads the first (non-data) line
materials = [];
more = true;
while more
    [matnum more] = fscanf(fid,'%d',1);
    if more
        [mattyp more] = fscanf(fid,'%s',1);
        if mattyp == 'PlaneStress'
            materials(matnum).typ = mattyp;
            [E more] = fscanf(fid,'%f',1);
            materials(matnum).E = E;
            [nu more] = fscanf(fid,'%f',1);
            materials(matnum).nu = nu;
            if (nargout == 6)
                [dens more] = fscanf(fid,'%f',1);
                materials(matnum).dens = dens;
                [strs_lim more] = fscanf(fid,'%f',1);
                materials(matnum).strs_lim = strs_lim;
            end
        elseif mattyp == 'PlaneStrain'
            materials(matnum).typ = mattyp;
            [E more] = fscanf(fid,'%f',1);
            materials(matnum).E = E;
            [nu more] = fscanf(fid,'%f',1);
            materials(matnum).nu = nu;
            if (nargout == 6)
                [dens more] = fscanf(fid,'%f',1);
                materials(matnum).dens = dens;
                [strs_lim more] = fscanf(fid,'%f',1);
                materials(matnum).strs_lim = strs_lim;
            end
        end
    end
end

% Read the Mesh Data
fgetl(fid); % This reads the first (non-data) line
[mesh more] = fscanf(fid,'%d',2);
Nnodes = mesh(1);
Nel    = mesh(2);
nodes = zeros(Nnodes,2); % Initialize Total number of Nodes
%elems = struct('typ', {}, 'matnum', {}, 'bxy', {}, 'conn', {}, 'edgeloads', {});
%elems(Nel).conn = []; % Initialize Total number of Elements
if (nargout == 6)
    [DynData more] = fscanf(fid, '%f', 6);
end
fgetl(fid); 

% Read the Nodes
fgetl(fid); % This reads the first (non-data) line
for inod = 1:Nnodes
    [xyzcoor more] = fscanf(fid,'%f',2);
    nodes(inod,:) = xyzcoor';
end
fgetl(fid); 

% nodes = [];
% more = true;
% while more
%     [xyzcoor more] = fscanf(fid,'%f',2);
%     nodes = [nodes; xyzcoor'];
% end

% Read the Elements - connectivity
fgetl(fid);
elems = [];
more = true;
while more
    [iel more] = fscanf(fid,'%d',1);
    if more
        [eltype more] = fscanf(fid,'%s',1);
        elems(iel).typ = eltype;
        [matnum more] = fscanf(fid,'%d',1);
        elems(iel).matnum = matnum;
        [bxy more] = fscanf(fid,'%f',2);
        elems(iel).bxy = bxy;
        if eltype == 'T3'
            [elem more] = fscanf(fid,'%d',3);
        elseif eltype == 'T6'
            [elem more] = fscanf(fid,'%d',6);
        elseif eltype == 'Q4'
            [elem more] = fscanf(fid,'%d',4);
        elseif eltype == 'Q8'
            [elem more] = fscanf(fid,'%d',8);
        end
        elems(iel).conn = elem';
        elems(iel).edgeloads = [];
    end
end

% Read the Displacement Boundary Conditions
fgetl(fid);
bcs = [];
more = true;
while more
    [bc more] = fscanf(fid,'%f',5);
    bcs = [bcs; bc'];
end

% Read the Edge Loads
fgetl(fid);
edgeloads = [];
more = true;
while more
    [iel more] = fscanf(fid,'%d',1);
    if more
        numedgeloads = size(elems(iel).edgeloads,1); % Current number of edge loads
        %[loadtype more] = fscanf(fid,'%d',1);
        %elems(iel).edgeloads(numedgeloads+1,1) = loadtype;
        [edgenum more] = fscanf(fid,'%d',1);
        elems(iel).edgeloads(numedgeloads+1,2) = edgenum;
        [tN more] = fscanf(fid,'%f',2);
        elems(iel).edgeloads(numedgeloads+1,3:4) = tN';
    end
end

% Read the Nodal Loads
fgetl(fid);
nodloads = [];
more = true;
while more
    [load more] = fscanf(fid,'%f',3);
    nodloads = [nodloads; load'];
end

fclose(fid); % Close the file
