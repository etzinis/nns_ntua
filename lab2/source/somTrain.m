function [ output_args ] = somTrain( patterns, epochMultiplier, rateLR)
    global maxNeighborDist tuneND orderLR orderSteps tuneLR;
    currND = maxNeighborDist;
    currLR = orderLR;
    
    display(maxNeighborDist);
    display(tuneND);
    display(orderSteps);
    orderNDs =exp(linspace(log(maxNeighborDist),log(tuneND), orderSteps));
    orderLRs =exp(linspace(log(orderLR),log(tuneLR), orderSteps));
    
    for i = 1:orderSteps
        display(i)
        for j = 1:size(patterns, 2)
            somUpdate(patterns(:,j), orderLRs(i), orderNDs(i));
        end
    end

    tuningSteps = orderSteps * epochMultiplier;
    
    currLR = tuneLR;
    for i = 1:tuningSteps
        display(i)
        for j = 1:size(patterns, 2)
            somUpdate(patterns(:,j), currLR, tuneND);
        end
        currLR = currLR * rateLR;
    end
    
end

