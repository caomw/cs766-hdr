% Gamma Compression

function [image] = toneMapGamma(radMap, gamma)
    
    image = radMap .^ gamma;
    
    maxVal = max(max(prctile(image,95)));
    image = image ./ maxVal;
    
end