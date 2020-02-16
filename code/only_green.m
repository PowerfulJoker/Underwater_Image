function y=only_green(Image)
im = im2double(Image);
%归一化处理
r=mat2gray(im(:,:,1));
g=mat2gray(im(:,:,2));
b=mat2gray(im(:,:,3));

avgR = mean(mean(r));
avgG = mean(mean(g));
avgB = mean(mean(b));

avgGray = (avgR + avgG + avgB)/3;
kg = avgGray/avgG;
kb = avgGray/avgB;
rc = r + (avgG - avgR).*(1-r).*g;
rc = min(rc,1);

newr = rc;%红色通道补偿
newg = kg * g; %灰色世界法
newb = kb * b;
y = cat(3,newr,newg,newb);