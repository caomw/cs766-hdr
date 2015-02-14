%function [ output_args ] = alignMTB( input_args )
img1 = imread('TestImages/Test3-1.jpg');
img2 = imread('TestImages/Test3-2.jpg');
int1 = img1(:,:,1) * 0.21 + img1(:,:,2) * 0.71 + img1(:,:,3) * 0.08;
int2 = img2(:,:,1) * 0.21 + img2(:,:,2) * 0.71 + img2(:,:,3) * 0.08;
bin1 = im2bw(int1, double(median(int1(:)))/255);
bin2 = im2bw(int2, double(median(int2(:)))/255);

score = nnz(xor(bin1,bin2));
dx = 0;
dy = 0;

moves = [-1 0; 1 0; 0 -1; 0 1];
for i = 1:100
   scores = zeros(4,1);
   scores(1) = nnz(xor(bin1, imtranslate(bin2, [dx-1 dy])));
   scores(2) = nnz(xor(bin1, imtranslate(bin2, [dx+1 dy])));
   scores(3) = nnz(xor(bin1, imtranslate(bin2, [dx dy-1])));
   scores(4) = nnz(xor(bin1, imtranslate(bin2, [dx dy+1])));
   
   [minScore, minIndex] = min(scores);
   if minScore < score
       dx = dx + moves(minIndex,1);
       dy = dy + moves(minIndex,2);
       score = minScore;
   else
       break;
   end
end

newImg2 = imtranslate(img2, [dx dy]);

figure;
imshow(img1 * 0.5 + img2 * 0.5);
figure;
imshow(img1 * 0.5 + newImg2 * 0.5)
%end

