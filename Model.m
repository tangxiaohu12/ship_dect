function [R,Circle_bw]=Model(M)
%**********************************R************************************%
             
Circle_bw=zeros(M,M);
c=[M/2 M/2];   % 圆心与半径
r=M/2;
Circle_bw(c(1),c(2))=1;
Circle_bw=bwdist(Circle_bw)<r;%  利用欧式距离 填充圆1
%*******算出各等分线的斜率
theta=(0:1/8:1)*pi; 
x=r*cos(theta)+M/2;
y=r*sin(theta)+M/2;
k=(y-(M/2)*ones(1,length(y)))./(x-(M/2)*ones(1,length(x)));  %斜率k 0~-0
%b=50-25*k;
for l =1:16 
    R(:,:,l)=zeros(M,M);
end

%**************1/4个扇形中的等分***********%
for l=1:4    
    for i=1:M/2
        for j=1:M
       
        ak=(i-M/2)/(j-M/2);   %各坐标点与圆心点的直线斜率注意此处坐标轴的变化，相当于在第四象限的x y 递增
        if ak>k(l)&&ak<k(l+1)  % 优化   k为无穷时的处理
            R(i,j,l)=Circle_bw(i,j);
        end    
    
        end
    end
    %figure,imshow(R(:,:,l),'InitialMagnification','fit')
end
%**************剩下的均为旋转***********%
for q=5:8 
      R(:,:,q)=rot90(R(:,:,q-4),-1);%k取负为顺时针
  %  figure,imshow(R(:,:,q),'InitialMagnification','fit')
end
for p=9:16 
      R(:,:,p)=rot90(R(:,:,p-8),2);
   % figure,imshow(R(:,:,p),'InitialMagnification','fit')
end

%*********************************R*******************************%