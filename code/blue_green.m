function y=blue_green(Image)
im = im2double(Image);
%��һ������
r=mat2gray(im(:,:,1));
g=mat2gray(im(:,:,2));
b=mat2gray(im(:,:,3));

avgR = mean(mean(r));
avgG = mean(mean(g));
avgB = mean(mean(b));

avgGray = (avgR + avgG + avgB)/3;
kg = avgGray/avgG;
%kb = avgGray/avgB;
rc = r + (avgG - avgR).*(1-r).*g;
bc = b + (avgG - avgB).*(1-b).*g;
rc = min(rc,1);
bc = min(bc,1);

newr = rc;%��ɫͨ������
newg = kg * g; %��ɫ���編
newb = bc; %��ɫͨ������
y = cat(3,newr,newg,newb);