%% Load exposure time
expTimes = 1 ./ load('TestImages/Test1-ExpTime.txt');
B = log(expTimes);
%% Load images
imgFiles = {'TestImages/Test1-1.jpg', 'TestImages/Test1-2.jpg', 'TestImages/Test1-3.jpg', 'TestImages/Test1-4.jpg', 'TestImages/Test1-5.jpg'};
imgNum = length(imgFiles);
imgInfo = imfinfo(char(imgFiles(1)));
height = imgInfo.Height;
width = imgInfo.Width;
imgs = zeros(height,width,3,imgNum);
for i=1:imgNum
    imgs(:,:,:,i) = imread(char(imgFiles(i)));
end
gImgs(:,:,:) = imgs(:,:,2,:);
%% Sample pixels
smpNumSqrt = round(sqrt(2*256/(imgNum - 1)));
smpNum = smpNumSqrt*smpNumSqrt;
k = 1;
Z = zeros(smpNum,imgNum);
for i=1:smpNumSqrt
   for j=1:smpNumSqrt
       y = round(i*height/(smpNumSqrt+1));
       x = round(j*width/(smpNumSqrt+1));
       Z(k,:) = gImgs(y,x,:);
       k = k+1;
   end
end
%% Construct weighting function
w = zeros(256,1);
for i=1:128
    w(i) = i - 1;
end
for i=129:256
    w(i) = 256 - i;
end
%% Assign lamda value
l = 20;

%% Solve for g and lE
[g,lE] = gSolve(Z,B,l,w);

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