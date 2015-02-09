% needs a bit of clean up (slow but vivid recreation)

% implementation of Drago et al. tone mapping algorithm
% Adaptive Logarithmic Mapping For Displaying High Contrast Scenes
% http://pages.cs.wisc.edu/~lizhang/courses/cs766-2012f/projects/hdr/Drago2003ALM.pdf

% BONUS!
function [image] = toneMap(radMap)
[Yxy, sum] = RGBtoYxy(radMap);

N = size(Yxy(:,:,1),1) * size(Yxy(:,:,1),2);
maxLum = max(max(Yxy(:,:,1)));
logAvgLum = sum / N;
avgLum = exp(logAvgLum);
b = 0.85; % this could be a parameter
maxLumW = (maxLum / avgLum);

newLum = nan(size(Yxy(:,:,1)));
coeff = 1 / log10(maxLumW + 1);
for row = 1:size(Yxy(:,:,1),1)
    for col = 1:size(Yxy(:,:,1),2)
        L_w = Yxy(row,col,1) / avgLum;
        newLum(row,col) = ( log(L_w + 1) / log(2 + bias((L_w / maxLumW), b) * 8) ) * coeff;
    end
end

Yxy(:,:,1) = newLum;
image = YxytoRGB(Yxy);

% correct gamma
image = fixGamma(image);
end

% Bias power function
function [bT] = bias(t ,b)
bT = t ^ ( log(b) / log(0.5) );
end

% RGB to Yxy
function [Yxy, total] = RGBtoYxy(RGB)
% convert to xyY
Yxy = nan(size(RGB));
RGB2Yxy = [ 0.5141364, 0.3238786, 0.16036376; ...
    0.265068, 0.67023428, 0.06409157; ...
    0.0241188, 0.1228178, 0.84442666];
total = 0.0;
for row = 1:size(RGB,1)
    for col = 1:size(RGB,2)
        
        result = zeros(1,3);
        for i = 1:3
            result(i) = result(i) + RGB2Yxy(i,1) * RGB(row,col,1);
            result(i) = result(i) + RGB2Yxy(i,2) * RGB(row,col,2);
            result(i) = result(i) + RGB2Yxy(i,3) * RGB(row,col,3);
        end
        
        W = sum(result);
        if W > 0.0
            Yxy(row,col,1) = result(2);     % Y
            Yxy(row,col,2) = result(1) / W;	% x
            Yxy(row,col,3) = result(2) / W;	% y
        else
            Yxy(row,col,1) = 0;     % Y
            Yxy(row,col,2) = 0;	% x
            Yxy(row,col,3) = 0;	% y
        end
        total = total + log(2.3e-5 + Yxy(row,col,1));
    end
end
end

% Yxy to RGB
function [RGB] = YxytoRGB(Yxy)
EPSILON = eps(1);

% convert to xyY
RGB = nan(size(Yxy));
Yxy2RGB = [ 2.5651, -1.1665, -0.3986; ...
    -1.0217, 1.9777, 0.0439; ...
    0.0753, -0.2543, 1.1892];

for row = 1:size(RGB,1)
    for col = 1:size(RGB,2)
        Y = Yxy(row,col,1);
        result(2) = Yxy(row,col,2);
        result(3) = Yxy(row,col,3);
        
        if ((Y > EPSILON) && (result(2) > EPSILON) && (result(3) > EPSILON))
            X = (result(2) * Y) / result(3);
            Z = (X / result(2)) - X - Y;
        else
            X = EPSILON;
            Z = EPSILON;
        end
        RGB(row,col,1) = X;
        RGB(row,col,2) = Y;
        RGB(row,col,3) = Z;
        result = zeros(1,3);
        for i = 1:3
            result(i) = result(i) + Yxy2RGB(i,1) * RGB(row,col,1);
            result(i) = result(i) + Yxy2RGB(i,2) * RGB(row,col,2);
            result(i) = result(i) + Yxy2RGB(i,3) * RGB(row,col,3);
        end
        RGB(row,col,1) = result(1);
        RGB(row,col,2) = result(2);
        RGB(row,col,3) = result(3);
    end
end
end

% fix gamma based on paper method
function [image] = fixGamma(oldImage)
slope = 4.5;
start = 0.018;
gammaval = 2.2; % fix?
fgamma = (0.45/gammaval)*2;

if gammaval >= 2.1
    start = 0.018 / ((gammaval - 2) * 7.5);
    slope = 4.5 * ((gammaval - 2) * 7.5);
elseif gammaval <= 1.9
    start = 0.018 * ((2 - gammaval) * 7.5);
    slope = 4.5 / ((2 - gammaval) * 7.5);
end

image = nan(size(oldImage));
for row = 1:size(oldImage,1)
    for col = 1:size(oldImage,2)
        %red
        if oldImage(row,col,1) <= start
            image(row,col,1) = oldImage(row,col,1) * slope;
        else
            image(row,col,1) = 1.099 * power(oldImage(row,col,1), fgamma) - 0.099;
        end
        
        %green
        if oldImage(row,col,2) <= start
            image(row,col,2) = oldImage(row,col,2) * slope;
        else
            image(row,col,2) = 1.099 * power(oldImage(row,col,2), fgamma) - 0.099;
        end
        
        %blue
        if oldImage(row,col,3) <= start
            image(row,col,3) = oldImage(row,col,3) * slope;
        else
            image(row,col,3) = 1.099 * power(oldImage(row,col,3), fgamma) - 0.099;
        end
        
    end
end
end