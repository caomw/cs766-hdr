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

Z = zeros(smpNum,imgNum);
k = 1;
miss = 0;
mnThreshold = 3;
bevThreshold = 6;
wevThreshold = 12;
relaxRate = 1.5;
while 1
    if miss >= 10
        mnThreshold = mnThreshold * relaxRate;
        bevThreshold = bevThreshold * relaxRate;
        wevThreshold = wevThreshold * relaxRate;
        miss = 0;
    end
    
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
    if nnz(increments < -mnThreshold) > 0
        %display(nnz(increments < -12));
        miss = miss + 1;
        continue;
    end
    % between-exposure variance check
    if pixels(imgNum) - pixels(1) <= bevThreshold
        %display(pixels(imgNum) - pixels(1));
        miss = miss + 1;
        continue;
    end
    % within-exposure variance check
    if std(double(neighbors(:))) > wevThreshold
        %display(std(double(neighbors(:))));
        miss = miss + 1;
        continue;
    end
    
    Z(k,:) = imgs(i,j,:);
    k = k + 1;
    miss = 0;
    if k > smpNum
        break;
    end
end
end

