str = '.\underwater\';
for i=1:9
   f = imread([str,num2str(i),'.jpg']);
   tic
   underwater_enhance(f);
   toc
end