function [ evaluation ] = somEvaluate( patterns)
    
    global IW;
    winning_distance = zeros(size(patterns,1), 1);
    for i = 1:size(patterns,2)
        pattern = patterns(:,i);
        distances = negdist(IW, pattern);
        winning_distance(i) = - max(distances);
    end
    evaluation = mean(winning_distance);
end

