function [ output ] = somOutput( pattern )
    global IW;
    distances = negdist(IW, pattern);
    output = compet(distances);
end

