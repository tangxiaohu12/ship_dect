
function [bw]=Img_PreProcess(gray)
% 1) ��ͼ�������ֵ�˲�(Ԥ����)
med_gray = medfilt2(gray,[5,5]);
figure;imshow(uint8(med_gray));

% ��ֱ��ͼ���⻯����ͼ����ǿ�󷴶�Ч��������
% enhanced_im = histeq(med_gray);
% figure;imshow(uint8(enhanced_im));

% 2) ���������䷽�(OTSU)���к�½�ָ�Ч���Ϻ�, 
% �������ö�ά���������۽��к�½�ָ�Ч������
level = graythresh(med_gray);
imBW = im2bw(med_gray,level*0.6);
figure;imshow(uint8(imBW*255)),title('��ֵ��');
% ���ö�ά���������۽��к�½�ָ�
% Segmentation = Entropy_Segmentation(med_gray);
% figure;imshow(uint8(Segmentation));

% 3) �Ժ�½�ָ���������̬ѧ�����������ն�, ���������С��һ����ֵ������
% ������ͱ�����
%se = strel('disk',5);
%morpholic_open = imclose(imBW,se);
morpholic_open=bwareaopen(imBW,50);
% ����ڲ��ն�
morpholic_fill = imfill(morpholic_open,'holes');
% ��ͨ�������,ȥ�����С��һ����ֵ������
area_Thresh = 100;
imLabel = bwlabel(morpholic_fill);                %�Ը���ͨ����б��
stats = regionprops(imLabel,'Area');    %�����ͨ��Ĵ�С
bw2 = ismember(imLabel, find([stats.Area] >= area_Thresh)); 
%figure;imshow(uint8(morpholic_fill*255));
figure;imshow(uint8(bw2*255));
bw=bw2*255;