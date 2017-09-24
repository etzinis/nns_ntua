function [ ] = somUpdate( pattern, learningRate, neighborDist )
    global IW N dimensions;
    activation = somActivation(pattern, neighborDist);
    delta_IW = learningRate * repmat(activation, 1, dimensions) .* (repmat(pattern', N, 1) - IW);
    IW = delta_IW + IW;
end

