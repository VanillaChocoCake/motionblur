clc;
clear;
img = imread("lena.png");
len = 30;
theta = -26;
psf = fspecial('motion', len, theta);
res = imfilter(img, psf, 'circular', 'conv');
imwrite(res, "new.png");