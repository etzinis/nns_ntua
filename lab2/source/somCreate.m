function somCreate(minMax,gridSize, topology, distance_function)

global neuronsPerRow neuronsPerColumn N IW distances dimensions positions;

neuronsPerRow = gridSize(1,1);
neuronsPerColumn = gridSize(1,2);
N = neuronsPerRow*neuronsPerColumn;

minFeatureValues = minMax(:,1)';
maxFeatureValues = minMax(:,2)';
dimensions = size(minMax,1);

IW = zeros(N,dimensions);

for i = 1:N,
    IW(i,:) = rand(1,dimensions).*(maxFeatureValues-minFeatureValues)+minFeatureValues;
end

if strcmp(topology, 'gridtop')
    positions = gridtop(neuronsPerRow,neuronsPerColumn);
elseif strcmp(topology, 'hextop')
    positions = hextop(neuronsPerRow,neuronsPerColumn);
elseif strcmp(topology, 'randtop')
    positions = randtop(neuronsPerRow,neuronsPerColumn);
elseif strcmp(topology, 'hexagonaltopology')
    positions = hexagonalTopology(neuronsPerRow,neuronsPerColumn);
end

if strcmp(distance_function, 'boxdist')
    distances = boxdist(positions);
elseif strcmp(distance_function, 'dist')
    distances = dist(positions);
elseif strcmp(distance_function, 'linkdist')
    distances = linkdist(positions);
elseif strcmp(distance_function, 'mandist')
    distances = mandist(positions);
elseif strcmp(distance_function, 'ring_distances')
    distances = ring_distances(N);
end
