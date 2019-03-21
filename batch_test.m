clear;close all
str ='D:\txh2018\ship_dect\≤‚ ‘Õº\test2\';
for loop_i=1:2
    
    gray1=imread([str,num2str(loop_i),'.tif']);
    gray=rgb2gray(gray1);  
    figure;imshow(gray)
    print(gcf,'-djpeg','-r2000',[str,num2str(loop_i),'.jpg'])
end