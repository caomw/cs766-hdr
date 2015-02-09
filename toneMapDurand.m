% from Durand and Dorsey (2002)
% incomplete trail

function image = toneMapDurand(radmap, offset, scale)
    Imap = radmap(:,:,1) * 0.299 + radmap(:,:,2) * 0.587 + radmap(:,:,3) * 0.114;
    Rmap = radmap(:,:,1) ./ Imap;
    Gmap = radmap(:,:,2) ./ Imap;
    Bmap = radmap(:,:,3) ./ Imap;
    Lmap = log2(Imap);
    h = fspecial('gaussian', [5 5], 1); % should be bilateral
    Base = imfilter(Lmap, h, 'replicate');
    Detail = Lmap - Base;
    Base2 = (Base - offset) * scale;
    Omap = power(2, Base2 + Detail);
    image(:,:,1) = Omap .* Rmap;
    image(:,:,2) = Omap .* Gmap;
    image(:,:,3) = Omap .* Bmap;
end

