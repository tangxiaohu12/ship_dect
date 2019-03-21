clear;close all

for loop_i=1  
str ='D:\txh2018\project_lab\ship_dect\vision9\test_img2\';
gray1=imread([str,num2str(loop_i),'.jpg']);
gray=rgb2gray(gray1);
%gray=imresize(gray2,[3600,3600]);
[m,n]=size(gray);

img=double(gray);
bw=Img_PreProcess(gray);

M=40; 
[R,Circle_bw]=Model(M);

%% 显著性角点及方向
[posx,posy,thea]=Feature_Vertor(bw,R,M);                                     %（0~pi ，-pi~0）
figure;imshow(gray),title('显著角点、方向');
Draw_circle(posx(:),posy(:), 0, M)
hold on
for i=1:size(thea,2)
    plot([posx(i)+M*cos(thea(i)),posx(i)],[posy(i)-M*sin(thea(i)),posy(i)],'y');
end
 
%% 舰首区域 点聚类、唯一舰首点
figure;
imshow(gray),title('舰首点及目标检测结果')
hold on
Cluster_img=zeros(m,n);
[MeanPos_f,dim]=Cluster_bow(Cluster_img,posx,posy,thea);      %  求唯一舰首， 方向弃用
plot(MeanPos_f(1,:),MeanPos_f(2,:), 'r*')
%%
Mod=100;
for i=1:dim
    [tmp_angle,nouse_hough_error]=hough_Angle(MeanPos_f(1:2,i),bw,Mod);
    bow_angle1(i)=tmp_angle;
end
%% 利用先验知识 舰首周围采样 （有检测局限弃用）
figure;imshow(bw),title('舰首周围采样');
[CorPosition_x,CorPosition_y,CorThea]=Sample_Cor(MeanPos_f(1,:),MeanPos_f(2,:),bow_angle1,bw/255);
plot(CorPosition_x(:),CorPosition_y(:), 'b*')
%CorPosition_x=posx;
%CorPosition_y=posy;
%CorThea=thea;
N = length(CorPosition_x(:));
% try
%       
% catch ErrorInfo                                                                  %捕获到的错误是一个MException对象 
%         disp(ErrorInfo);
%         break;
% end
MeanPos(1,:)=CorPosition_x(:);
MeanPos(2,:)=CorPosition_y(:);
MeanPos(3,:)=CorThea;

figure;
imshow(gray1),title('目标检测结果')
hold on
%% hough_line()--方向redefine 、剔除虚警 /CacuObj_L_W()--框定目标、剔除虚警
for i=1:N
     S=2*M;
     if MeanPos(2,i)-S>0&&MeanPos(1,i)-S>0&&MeanPos(2,i)+S<m&&MeanPos(1,i)+S<n
            [bow_angle,hough_error,Angle_MSE]=hough_line(MeanPos(1:2,i),MeanPos(3,i),bw);
              angle(i)=bow_angle;
              MSE(i)=Angle_MSE;
            [Object_length,object_width,length_error,width_error]=CacuObj_L_W(bw,[MeanPos(1,i),MeanPos(2,i)],bow_angle);
            if length_error==0&&width_error==0&&hough_error==0
                %plot([MeanPos(1,i)+M*cos(bow_angle),MeanPos(1,i)],[MeanPos(2,i)-M*sin(bow_angle),MeanPos(2,i)],'y','Linewidth',0.05);
                Get_Local_img(MeanPos(:,i),bow_angle,Object_length,object_width);
            end 
     else
         S=M;
         if MeanPos(2,i)-S>0&&MeanPos(1,i)-S>0&&MeanPos(2,i)+S<m&&MeanPos(1,i)+S<n
             [bow_angle,hough_error,Angle_MSE]=hough_line(MeanPos(1:2,i),MeanPos(3,i),bw);
             angle(i)=bow_angle;
              MSE(i)=Angle_MSE;
             [Object_length,object_width,length_error,width_error]=CacuObj_L_W(bw,[MeanPos(1,i),MeanPos(2,i)],bow_angle);
             if length_error==0&&width_error==0&&hough_error==0
                 %plot([MeanPos(1,i)+M*cos(bow_angle),MeanPos(1,i)],[MeanPos(2,i)-M*sin(bow_angle),MeanPos(2,i)],'y','Linewidth',0.05);
                 Get_Local_img(MeanPos(:,i),bow_angle,Object_length,object_width);
             end
         else
            disp('已略去边界点.')
         end
     end
end
hold off
print(gcf,'-djpeg','-r2000',[str,num2str(loop_i),'.png'])
clear;
end



