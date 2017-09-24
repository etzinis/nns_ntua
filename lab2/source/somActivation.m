function [ result ] = somActivation( pattern, neighborDist )
    global distances N;
    s_output = somOutput(pattern);
    winner = find(s_output > 0);
    neighbours = distances(winner,:) <= neighborDist;
    
    result = zeros(N,1);
    result(neighbours) = 0.5;
    result(winner) = 1;
end

