
function [bw]=Img_PreProcess(gray)
% 1) 对图像进行中值滤波(预处理)
med_gray = medfilt2(gray,[5,5]);
figure;imshow(uint8(med_gray));

% 用直方图均衡化进行图像增强后反而效果并不好
% enhanced_im = histeq(med_gray);
% figure;imshow(uint8(enhanced_im));

% 2) 利用最大类间方差法(OTSU)进行海陆分割效果较好, 
% 反而利用二维熵门限理论进行海陆分割效果不好
level = graythresh(med_gray);
imBW = im2bw(med_gray,level*0.6);
figure;imshow(uint8(imBW*255)),title('二值化');
% 利用二维熵门限理论进行海陆分割
% Segmentation = Entropy_Segmentation(med_gray);
% figure;imshow(uint8(Segmentation));

% 3) 对海陆分割结果进行形态学处理，以消除空洞, 并消除面积小于一定阈值的区域
% 开运算和闭运算
%se = strel('disk',5);
%morpholic_open = imclose(imBW,se);
morpholic_open=bwareaopen(imBW,50);
% 填充内部空洞
morpholic_fill = imfill(morpholic_open,'holes');
% 连通区域分析,去除面积小于一定阈值的区域
area_Thresh = 100;
imLabel = bwlabel(morpholic_fill);                %对各连通域进行标记
stats = regionprops(imLabel,'Area');    %求各连通域的大小
bw2 = ismember(imLabel, find([stats.Area] >= area_Thresh)); 
%figure;imshow(uint8(morpholic_fill*255));
figure;imshow(uint8(bw2*255));
bw=bw2*255;