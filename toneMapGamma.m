% Reinhard basic (no Automatic dodging-and-burning)

function [image] = toneMapGamma(radMap, gamma)
    
    radMap = log(radMap);
    maxRad = max(max(radMap));
    A = (1 ./ maxRad) .^ gamma;

    image(:,:,1) = A(1) * (radMap(:,:,1) .^ gamma);
    image(:,:,2) = A(2) * (radMap(:,:,2) .^ gamma);
    image(:,:,3) = A(3) * (radMap(:,:,3) .^ gamma);
end