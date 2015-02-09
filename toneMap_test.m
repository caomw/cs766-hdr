%% Input
expTimes = 1 ./ load('TestImages/memorial/memorial-shutterspeeds.txt');
imgFiles = {'TestImages/memorial/memorial0061.png','TestImages/memorial/memorial0062.png','TestImages/memorial/memorial0063.png','TestImages/memorial/memorial0064.png','TestImages/memorial/memorial0065.png','TestImages/memorial/memorial0066.png','TestImages/memorial/memorial0067.png','TestImages/memorial/memorial0068.png','TestImages/memorial/memorial0069.png','TestImages/memorial/memorial0070.png','TestImages/memorial/memorial0071.png','TestImages/memorial/memorial0072.png','TestImages/memorial/memorial0073.png','TestImages/memorial/memorial0074.png','TestImages/memorial/memorial0075.png','TestImages/memorial/memorial0076.png'};

%% Build rad map and save file
radmap = makeRadmap(imgFiles,expTimes,20);
hdrwrite(radmap,'TestImages/memorial/memorial.hdr');
hdrImage = hdrread('TestImages/memorial/memorial.hdr');

% Reinhard basic implementation of tone map
ReinhardRGB = toneMapBasic(hdrImage);
figure;
imshow(ReinhardRGB)
title('Reinhard')

% gamma compression tone mapping
gamma = 0.5;
GammaRGB = toneMapGamma(hdrImage, gamma);
figure;
imshow(GammaRGB)
title('Gamma')

% Drago et al. tone mapping algorithm
b = 0.85; %tuneable 0.7 - 1.0 (default is 0.85)
DragoRGB = toneMap(hdrImage, b);
figure;
imshow(DragoRGB)
title('Drago')

% compare with built in tonemap
builtInRGB = tonemap(hdrImage);
figure;
imshow(builtInRGB)
title('MATLAB builtin')