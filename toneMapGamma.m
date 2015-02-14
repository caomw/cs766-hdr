% Gamma Compression

function [image] = toneMapGamma(radMap, gamma)
    
    image = radMap .^ gamma;
    
    maxVal = max(max(max(image)));
    image = image ./ maxVal;
    
end