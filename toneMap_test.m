%% Input
expTimes = 1 ./ load('TestImages/Test1-ExpTime.txt');
imgFiles = {'TestImages/Test1-1.jpg', 'TestImages/Test1-2.jpg', 'TestImages/Test1-3.jpg', 'TestImages/Test1-4.jpg', 'TestImages/Test1-5.jpg'};
%% Function call
radmap = makeRadmap(imgFiles,expTimes,20);

% Reinhard basic implementation of tone map
ReinhardRGB = toneMapBasic(radmap);
figure;
imshow(ReinhardRGB)

% gamma compression tone mapping
GammaRGB = toneMapGamma(radmap, 0.5);
figure;
imshow(GammaRGB)

% compare with built in tonemap
builtInRGB = tonemap(radmap);
figure;
imshow(builtInRGB)