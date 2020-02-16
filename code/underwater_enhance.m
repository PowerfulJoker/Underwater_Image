function mr = underwater_enhance(Img)
%白平衡处理
%fb = only_green(Img);
fb = auto_white(Img);
%fb = blue_green(Img);
%对白平衡处理后的图像进行锐化
fs = imsharp(fb);
%对白平衡处理后的图像进行gamma变换
gam = 2;
fg = imadjust(fb, [ ], [ ], gam);

%锐化和gamma变换后的图像的三个权重
w = Laplacian_weight(fs);
ws = saliency_detection(fs);
wsa = Saturation_weight(fs);
w2 = Laplacian_weight(fg);
ws2 = saliency_detection(fg);
wsa2 = Saturation_weight(fg);
%将两组权重分别进行归一化
weight1 = (w+ws+wsa+0.1)./(w+ws+wsa+w2+ws2+wsa2+0.2);
weight2 = (w2+ws2+wsa2+0.1)./(w+ws+wsa+w2+ws2+wsa2+0.2);

%将归一化权重图分解成高斯金字塔，将锐化和gamma变换后的图像分解成拉普拉斯金字塔
n = 10;
g1 = gaussianPyramid(weight1,n);
g2 = gaussianPyramid(weight2,n);
l1 = laplaPyramid(fs,n);
l2 = laplaPyramid(fg,n);

%将权重高斯金字塔和拉普拉斯金字塔进行融合成新的金字塔
r = cell(n,1);
for i = 1:n
    r{i} = g1{i}.*im2double(l1{i}) + g2{i}.*im2double(l2{i});
end
%将新的金字塔进行融合
for i = n:-1:2
    t = imresize(r{i},2,'bilinear'); %插值
    t = t(1:size(r{i-1},1),1:size(r{i-1},2));%对行列数进行统一
    r{i-1} = t + r{i-1}; 
end
mr = r{1};
%将处理完成的图像转换成原图像格式
c = class(Img);
switch c
case 'uint8'
   mr = im2uint8(mr);
case 'uint16'
   mr = im2uint16(mr);
case 'double'
   mr = im2double(mr);
otherwise
   error('Unsupported IPT data class.');
end
figure,imshow([Img mr]);