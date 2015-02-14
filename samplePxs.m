function Z = samplepxs(imgs)
%% Really naive sampler
imgNum = size(imgs,3);
smpNumSqrt = round(sqrt(5*256/(imgNum - 1)));
smpNum = smpNumSqrt*smpNumSqrt;
height = size(imgs,1);
width = size(imgs,2);
k = 1;
Z = zeros(smpNum,imgNum);
for i=1:smpNumSqrt
   for j=1:smpNumSqrt
       y = round(i*height/(smpNumSqrt+1));
       x = round(j*width/(smpNumSqrt+1));
       Z(k,:) = imgs(y,x,:);
       k = k+1;
   end
end
end

