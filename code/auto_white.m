function y=auto_white(Image)
im = im2double(Image);
r=mat2gray(im(:,:,1));
g=mat2gray(im(:,:,2));
b=mat2gray(im(:,:,3));

avgR = mean(mean(r));
avgG = mean(mean(g));
avgB = mean(mean(b));
factor = avgG/avgB;

avgGray = (avgR + avgG + avgB)/3;
kg = avgGray/avgG;
kb = avgGray/avgB;
rc = r + (avgG - avgR).*(1-r).*g;
bc = b + (avgG - avgB).*(1-b).*g;
rc = min(rc,1);
bc = min(bc,1);

newr = rc;%红色通道补偿
newg = kg * g; %灰色世界法
if(factor>1.8)
    newb = bc; %蓝色通道补偿
else 
    newb = kb * b;%灰色世界法
end
y = cat(3,newr,newg,newb);