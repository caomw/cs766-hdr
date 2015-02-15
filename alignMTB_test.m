%% Input
imgFiles = {'TestImages/Test3-1.jpg', 'TestImages/Test3-2.jpg'};
%% Function call
imgs = loadImages(imgFiles);
alignedImgs = alignMTB(imgs, 0.2);
%% Show Results
figure;
imshow(imgs(:,:,:,1) * 0.5 + imgs(:,:,:,2) * 0.5);
figure;
imshow(alignedImgs(:,:,:,1) * 0.5 + alignedImgs(:,:,:,2) * 0.5)