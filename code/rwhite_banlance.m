str = '.\underwater\';
for i=1:9
   f = imread([str,num2str(i),'.jpg']);
   tic
   wb = auto_white(f);
   figure,imshow(wb,[ ])
   toc
end