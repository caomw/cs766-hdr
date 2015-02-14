% from Durand and Dorsey (2002)
% incomplete trail

function image = toneMapDurand(radmap, contrast)
    Imap = (radmap(:,:,1) * 20 + radmap(:,:,2) * 40 + radmap(:,:,3) * 1) / 61;
    Rmap = radmap(:,:,1) ./ Imap;
    Gmap = radmap(:,:,2) ./ Imap;
    Bmap = radmap(:,:,3) ./ Imap;
    
    lImap = log10(Imap);
    filter = fspecial('gaussian', [3 3], 1.0); % should be bilateral
    lBase = imfilter(lImap, filter, 'replicate');
    lDetail = lImap - lBase;
    Scale = log10(contrast) / (max(max(lBase)) - min(min(lBase)));
    Offset = max(max(lBase)) * Scale;
    lOmap = lBase * Scale + lDetail - Offset;
    Omap = 10 .^ lOmap;
    
    image(:,:,1) = Omap .* Rmap;
    image(:,:,2) = Omap .* Gmap;
    image(:,:,3) = Omap .* Bmap;
    maxVal = max(max(prctile(image,95)));
    image = image / maxVal;
end
