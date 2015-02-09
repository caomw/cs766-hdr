%% Input
expTimes = 1 ./ load('TestImages/Test1-ExpTime.txt');
imgFiles = {'TestImages/Test1-1.jpg', 'TestImages/Test1-2.jpg', 'TestImages/Test1-3.jpg', 'TestImages/Test1-4.jpg', 'TestImages/Test1-5.jpg'};
%% Function call
radmap = makeRadmap(imgFiles,expTimes,20);
hdrwrite(radmap,'TestImages/Test1.hdr');
hdrImage = hdrread('TestImages/Test1.hdr');

% Reinhard basic implementation of tone map
ReinhardRGB = toneMapBasic(hdrImage);
figure;
imshow(ReinhardRGB)
title('Reinhard')

% gamma compression tone mapping
GammaRGB = toneMapGamma(hdrImage, 0.5);
figure;
imshow(GammaRGB)
title('Gamma')

% Drago et al. tone mapping algorithm
DragoRGB = toneMap(hdrImage);
figure;
imshow(DragoRGB)
title('Drago')

% compare with built in tonemap
builtInRGB = tonemap(hdrImage);
figure;
imshow(builtInRGB)
title('MATLAB builtin')