function [materials, nodes, elems, bcs, nodloads, DynData] = ThreeDFEgetinput(inpfilename)

% Read the input file
fid = fopen(inpfilename,'r');

% Read the Material Data
fgetl(fid); % This reads the first (non-data) line
materials = [];
more = true;
while more
    [matnum more] = fscanf(fid,'%d',1);
    if more
        [mattyp more] = fscanf(fid,'%s',1);
        if mattyp == 'HookesMat'
            materials(matnum).typ = mattyp;
            [E more] = fscanf(fid,'%f',1);
            materials(matnum).E = E;
            [nu more] = fscanf(fid,'%f',1);
            materials(matnum).nu = nu;
            [dens more] = fscanf(fid,'%f',1);
            materials(matnum).dens = dens;
            [strs_lim more] = fscanf(fid,'%f',1);
            materials(matnum).strs_lim = strs_lim;
        end
    end
end

% Read the Mesh Data
fgetl(fid); % This reads the first (non-data) line
[mesh more] = fscanf(fid,'%d',2);
Nnodes = mesh(1);
Nel    = mesh(2);
nodes = zeros(Nnodes,3); % Initialize Total number of Nodes
elems = struct('typ', {}, 'matnum', {}, 'bxyz', {}, 'conn', {}, 'faceloads', {});
elems(Nel).conn = []; % Initialize Total number of Elements
[DynData more] = fscanf(fid,'%f',7);
fgetl(fid); 

% Read the Nodes
fgetl(fid); % This reads the first (non-data) line
for inod = 1:Nnodes
    [xyzcoor more] = fscanf(fid,'%f',3);
    nodes(inod,:) = xyzcoor';
end
fgetl(fid); 

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
        [bxyz more] = fscanf(fid,'%f',3);
        elems(iel).bxyz = bxyz;
        if eltype == 'T4'
            [elem more] = fscanf(fid,'%d',4);
        end
        elems(iel).conn = elem';
        elems(iel).faceloads = [];
        elems(iel).flag = 1;
    end
end

% Read the Displacement Boundary Conditions
fgetl(fid);
bcs = [];
more = true;
while more
    [bc more] = fscanf(fid,'%f',7);
    bcs = [bcs; bc'];
end

% Read the Face Loads
fgetl(fid);
faceloads = [];
more = true;
while more
    [iel more] = fscanf(fid,'%d',1);
    if more
        numfaceloads = size(elems(iel).faceloads,1); % Current number of edge loads
        [facenum more] = fscanf(fid,'%d',1);
        elems(iel).faceloads(numfaceloads+1,1) = facenum;
        [load_type more] = fscanf(fid,'%d',1);
        elems(iel).faceloads(numfaceloads+1,2) = load_type;
        [tN more] = fscanf(fid,'%f',3);
        elems(iel).faceloads(numfaceloads+1,3:5) = tN';
    end
end

% Read the Nodal Loads
fgetl(fid);
nodloads = [];
more = true;
while more
    [load more] = fscanf(fid,'%f',5);
    nodloads = [nodloads; load'];
end

fclose(fid); % Close the file
