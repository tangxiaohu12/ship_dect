%*******利用原始角点和方向信息通过hough line变换求出精确的舰船方向************%
%*******针对原始方向信息在舰船处于接近水平方向时不稳定（从0到2pi突变导致多变）的情况进行解决*******%
function [bow_angle,hough_error,Angle_MSE]=hough_line(MeanPos,MeanThea,bw)
%% hough line
hough_error=0;
M=100;
Cut_center_x=round(MeanPos(1,1)+M*cos(MeanThea));                                %通过原始点和方向得到cut_img中心点
Cut_center_y=round(MeanPos(2,1)-M*sin(MeanThea));
try
    bw_block=bw(Cut_center_y-M:Cut_center_y+M-1,Cut_center_x-M:Cut_center_x+M-1);%(M+1)*(M+1)   
catch ErrorInfo                                                                  %捕获到的错误是一个MException对象 
    disp(ErrorInfo);
    hough_error=1;
    bow_angle=0;
    Angle_MSE=-1;
    return
end
thresh=[0.01,0.17];    
sigma=2;                                                                           %定义高斯参数    
blockedge = edge(double(bw_block),'canny',thresh,sigma);    
%figure(1),imshow(blockedge,[]);
title('Final—result');
[H, theta, rho]= hough(blockedge);
peak=houghpeaks(H,20);
hold on
lines=houghlines(blockedge,theta,rho,peak,'FillGap',5,'MinLength',20);             %设置直线参数
if isempty(lines)
    hough_error=1;
    bow_angle=0;
    Angle_MSE=-1;
    return
else
    hough_error=0;
end
max_len = 0;
%figure,imshow(blockedge,[]),title('Hough Transform Detect Result'),hold on    
for k=1:length(lines)    
    xy=[lines(k).point1;lines(k).point2];    
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green'); 
%    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
    len = norm(lines(k).point1 - lines(k).point2);
    Line_theta(k)=lines(k).theta;
   if ( len > max_len)
      max_len = len;
      max_theta=lines(k).theta;
      xy_long = xy;
   end
end
plot(xy_long(:,1),xy_long(:,2),'LineWidth',0.01,'Color','red');
%% 利用标准差筛选掉不合理对象   
Angle_MSE=std(Line_theta);
if Angle_MSE>15
    hough_error=0;
end
%% 角度优化 取众数 或 max_theta
mode_theta=mode(Line_theta);                                                        %没有众数取最小数
unique_theta= unique(Line_theta);
if size(unique_theta)==length(lines) 
    better_theta=max_theta;
else
    better_theta=mode_theta;
end
%% hough line 角度（-90 0 90）对应到 0 - 2*Pi  利用地理先验知识语义采样的方式（弃用-vision5利用原始方向确定的方式）

Radius=7;
Mask = zeros(2*Radius,2*Radius);
c = [Radius Radius];   
Mask(c(1),c(2)) = 1;
Mask=bwdist(Mask) < Radius;
Length=25;
if better_theta>=0
    a1=(90-better_theta)*pi/180;
    a2=(270-better_theta)*pi/180;
    SampPos_1_x=round(MeanPos(1,1)+Length*cos(a1));
    SampPos_1_y=round(MeanPos(2,1)-Length*sin(a1));

    SampPos_2_x=round(MeanPos(1,1)+Length*cos(a2));
    SampPos_2_y=round(MeanPos(2,1)-Length*sin(a2));

else
    a1=(180-(90-abs(better_theta)))*pi/180;
    a2=-(90-abs(better_theta))*pi/180;

    SampPos_1_x=round(MeanPos(1,1)+Length*cos(a1));
    SampPos_1_y=round(MeanPos(2,1)-Length*sin(a1));

    SampPos_2_x=round(MeanPos(1,1)+Length*cos(a2));
    SampPos_2_y=round(MeanPos(2,1)-Length*sin(a2));
end
 %plot([SampPos_1_x,SampPos_2_x],[SampPos_1_y,SampPos_2_y],'b:','LineWidth',1.75);
  Block1=bw(SampPos_1_y-Radius:SampPos_1_y+Radius-1,SampPos_1_x-Radius:SampPos_1_x+Radius-1);
  Block2=bw(SampPos_2_y-Radius:SampPos_2_y+Radius-1,SampPos_2_x-Radius:SampPos_2_x+Radius-1);
  Circle_Sector1=Block1.*Mask;
  Circle_Sector2=Block2.*Mask;
 if sum(Circle_Sector1(:))==0&&sum(Circle_Sector2(:))>=1*Radius*Radius*pi/5
     bow_angle=a2;
 elseif sum(Circle_Sector1(:))>=1*Radius*Radius*pi/5&&sum(Circle_Sector2(:))==0
     bow_angle=a1;
 else
     hough_error=1;
     bow_angle=0;
 end
 
     
     
     
     