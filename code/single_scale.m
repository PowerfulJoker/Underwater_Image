function mr = single_scale(Img)
%白平衡处理
%fb = only_green(Img);
fb = auto_white(Img);
%fb = blue_green(Img);
%对白平衡处理后的图像进行锐化
fs = imsharp(fb);
%对白平衡处理后的图像进行gamma变换
gam = 1.5;
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

gh = fspecial('gaussian',5,0.5*(10^(0.5)));
g1 = imfilter(weight1,gh,'conv','same','replicate');
g2 = imfilter(weight2,gh,'conv','same','replicate');

%拉普拉斯滤波近似
h = fspecial('gaussian',5);

t1 = imfilter(fs,h,'conv','same','replicate');
down1 = t1(1:2:end,1:2:end,:);
up1 = imresize(down1,2,'bilinear');
up1 = up1(1:size(fs,1),1:size(fs,2));
%up1 = imfilter(up1,h,'conv','same','replicate');
la1 = fs - up1;

t2 = imfilter(fg,h,'conv','same','replicate');
down2 = t2(1:2:end,1:2:end,:);
up2 = imresize(down2,2,'bilinear');
up2 = up2(1:size(fg,1),1:size(fg,2));
%up2 = imfilter(up2,h,'conv','same','replicate');
la2 = fg - up2;

r1 = (g1 + 0.2*abs(la1)).*fs;
r2 = (g2 + 0.2*abs(la2)).*fg;

mr = r1+r2;
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