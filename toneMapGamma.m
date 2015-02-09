% Gamma Compression

function [image] = toneMapGamma(radMap, gamma)
    
    image = radMap .^ gamma;
    
end