%% Input
expTimes = 1 ./ load('TestImages/Test2-ExpTime.txt');
imgFiles = {'TestImages/Test2-1.png', 'TestImages/Test2-2.png', 'TestImages/Test2-3.png', 'TestImages/Test2-4.png', 'TestImages/Test2-5.png', 'TestImages/Test2-6.png', 'TestImages/Test2-7.png', 'TestImages/Test2-8.png', 'TestImages/Test2-9.png', 'TestImages/Test2-10.png', 'TestImages/Test2-11.png', 'TestImages/Test2-12.png', 'TestImages/Test2-13.png', 'TestImages/Test2-14.png', 'TestImages/Test2-15.png', 'TestImages/Test2-16.png'};

%% Build rad map and save file
radmap = makeRadmap(imgFiles,expTimes,20);
hdrwrite(radmap,'TestImages/Test2.hdr');
%hdrImage = hdrread('TestImages/Test2.hdr');

% Reinhard basic implementation of tone map
ReinhardRGB = toneMapBasic(radmap);
figure;
imshow(ReinhardRGB,[])
title('Reinhard')

% gamma compression tone mapping
gamma = 0.5;
GammaRGB = toneMapGamma(radmap, gamma);
figure;
imshow(GammaRGB,[])
title('Gamma')

% Drago et al. tone mapping algorithm
b = 0.85; %tuneable 0.7 - 1.0 (default is 0.85)
DragoRGB = toneMapDrago(radmap, b);
figure;
imshow(DragoRGB,[])
title('Drago')

% compare with built in tonemap
builtInRGB = tonemap(radmap);
figure;
imshow(builtInRGB,[])
title('MATLAB builtin')