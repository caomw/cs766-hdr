%% Construct radiance map
E = mergeExps(gImgs,B,g,w);
%% Display radiance map in false color
figure;
imshow(E,[],'Colormap',jet(256));
colorbar;
%% Simple gamma correction
gamma = 0.025;
newImg = power(E,gamma);
figure;
imshow(newImg,[]);