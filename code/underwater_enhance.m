function mr = underwater_enhance(Img)
%��ƽ�⴦��
%fb = only_green(Img);
fb = auto_white(Img);
%fb = blue_green(Img);
%�԰�ƽ�⴦����ͼ�������
fs = imsharp(fb);
%�԰�ƽ�⴦����ͼ�����gamma�任
gam = 2;
fg = imadjust(fb, [ ], [ ], gam);

%�񻯺�gamma�任���ͼ�������Ȩ��
w = Laplacian_weight(fs);
ws = saliency_detection(fs);
wsa = Saturation_weight(fs);
w2 = Laplacian_weight(fg);
ws2 = saliency_detection(fg);
wsa2 = Saturation_weight(fg);
%������Ȩ�طֱ���й�һ��
weight1 = (w+ws+wsa+0.1)./(w+ws+wsa+w2+ws2+wsa2+0.2);
weight2 = (w2+ws2+wsa2+0.1)./(w+ws+wsa+w2+ws2+wsa2+0.2);

%����һ��Ȩ��ͼ�ֽ�ɸ�˹�����������񻯺�gamma�任���ͼ��ֽ��������˹������
n = 10;
g1 = gaussianPyramid(weight1,n);
g2 = gaussianPyramid(weight2,n);
l1 = laplaPyramid(fs,n);
l2 = laplaPyramid(fg,n);

%��Ȩ�ظ�˹��������������˹�����������ںϳ��µĽ�����
r = cell(n,1);
for i = 1:n
    r{i} = g1{i}.*im2double(l1{i}) + g2{i}.*im2double(l2{i});
end
%���µĽ����������ں�
for i = n:-1:2
    t = imresize(r{i},2,'bilinear'); %��ֵ
    t = t(1:size(r{i-1},1),1:size(r{i-1},2));%������������ͳһ
    r{i-1} = t + r{i-1}; 
end
mr = r{1};
%��������ɵ�ͼ��ת����ԭͼ���ʽ
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