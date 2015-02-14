function [radmap] = makeRadmap(imgFiles,expTimes,smoothness)
%% Load exposure time
B = log(expTimes);
%% Load images
imgNum = length(imgFiles);
imgInfo = imfinfo(char(imgFiles(1)));
height = imgInfo.Height;
width = imgInfo.Width;
imgs = zeros(height,width,3,imgNum);
for i=1:imgNum
    imgs(:,:,:,i) = imread(char(imgFiles(i)));
end
rImgs(:,:,:) = imgs(:,:,1,:);
gImgs(:,:,:) = imgs(:,:,2,:);
bImgs(:,:,:) = imgs(:,:,3,:);
%% Sample pixels
rZ = samplePxs(rImgs);
gZ = samplePxs(gImgs);
bZ = samplePxs(bImgs);
%% Construct weighting function
w = zeros(256,1);
for i=1:128
    w(i) = i;
end
for i=129:256
    w(i) = 257 - i;
end
%% Solve for g and lE
rG = gSolve(rZ,B,smoothness,w);
gG = gSolve(gZ,B,smoothness,w);
bG = gSolve(bZ,B,smoothness,w);
%% Construct radiance map
rE = mergeExps(rImgs,B,rG,w);
gE = mergeExps(gImgs,B,gG,w);
bE = mergeExps(bImgs,B,bG,w);
radmap = cat(3,rE,gE,bE);
end