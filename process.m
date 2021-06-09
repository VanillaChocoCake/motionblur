clc;
clear;
img = imread("lena_0.png");
[height, width] = size(img);
Fourier = fft2(img);
H = log(1+abs(Fourier));
H = fftshift(H);
stage1 = normalization(H);
% imwrite(stage1, "1.png");
Threshold = graythresh(H);
BW = edge(H, 'canny', Threshold);
stage2 = normalization(BW);
% imshow(stage2, []);
% imwrite(stage2, "2.png");
theta = 1:180;
R = radon(BW, theta);
stage3 = normalization(R);
% imwrite(stage3, "3.png");
MAX = max(max(R));
[m, n] = find(R == MAX);
beta = atan(tan(n * pi / 180) * height / width) * 180 / pi;
len = 9;
PSF = fspecial("motion", len, beta);
img = im2double(img);
imgVar = var(img(:));
res = deconvwnr(img, PSF, 1e-5 ./ imgVar);
imshow(res, []);
imwrite(res, "res.png");
Threshold = graythresh(res);
BW = edge(res, 'canny', Threshold * 0.4);
figure;
imshow(BW, []);
res = normalization(BW);
imwrite(BW, "edge.png");


% 归一化，不然存的图片很奇怪
function res = normalization(img)
    max_value = max(max(img));
    min_value = min(min(img));
    res = img;
    res = (res - min_value) / (max_value - min_value);
end