function Z = samplePxs(imgs)
%% uniform sampler
%imgNum = size(imgs,3);
%smpNumSqrt = round(sqrt(2*256/(imgNum - 1)));
%smpNum = smpNumSqrt*smpNumSqrt;
%height = size(imgs,1);
%width = size(imgs,2);
%k = 1;
%Z = zeros(smpNum,imgNum);
%for i=1:smpNumSqrt
%   for j=1:smpNumSqrt
%       y = round(i*height/(smpNumSqrt+1));
%       x = round(j*width/(smpNumSqrt+1));
%       Z(k,:) = imgs(y,x,:);
%       k = k+1;
%   end
%end
%% random sampler
imgNum = size(imgs,3);
smpNum = round(2*256/(imgNum - 1));
height = size(imgs,1);
width = size(imgs,2);
k = 1;
Z = zeros(smpNum,imgNum);
while 1
    i = floor(rand() * (height - 2)) + 2;
    j = floor(rand() * (width - 2)) + 2;
    
    pixels = squeeze(imgs(i,j,:));
    if pixels(imgNum) < pixels(1)
        pixels = flip(pixels);
    end
    increments = zeros(imgNum - 1);
    for l = imgNum:-1:2
        increments(l-1) = pixels(l) - pixels(l-1);
    end
    neighbors = imgs(i-1:i+1,j-1:j+1,round(imgNum/2));
    
    % monotonicity check
    if nnz(increments < -12) > 0
        %display(nnz(increments < -12));
        continue;
    end
    % between-exposure variance check
    if pixels(imgNum) - pixels(1) <= 24
        %display(pixels(imgNum) - pixels(1));
        continue;
    end
    % within-exposure variance check
    if std(double(neighbors(:))) > 36
        %display(std(double(neighbors(:))));
        continue;
    end
    
    Z(k,:) = imgs(i,j,:);
    k = k + 1;
    if k > smpNum
        break;
    end
end
end

