%*********ͨ�����ģ����������������**********************%

function [posx,posy,thea]=Feature_Vertor(bw,R,M)
K=pi/4;
Sumpiexl=(M*M)*K*255;
Thresh=4/28*Sumpiexl;
[m,n]=size(bw);                                                                               
Feature(1:m,1:n,1:16)=0;                                                      %����������
for h=1:16
    Feature(:,:,h)=imfilter(bw,R(:,:,h));                                     %����ó�һ��ͼ���IRn ÿһ�� 16ά�������� 
end
u=1;
for i=60:m-60+1
    for j= 60:n-60+1
          A(1,:)=Feature(i,j,:);
          [sA,index] = sort(A);     
          sA3=sA(13:16);
          sum3 =sum(sA3,2);    
          sumall=sum(A,2);
          ratio1 =sum3/sumall;
          if (ratio1>0.88)&&(sumall>Thresh)&&sA(1,16)>Sumpiexl/19
              posy(u)=i;            
              posx(u)=j;
              thea(u)=pi-(2*pi*index(1,16)/16-pi/32);                           %ע��˴�theata ��ʱ�����α仯( 0~pi�� -pi~0)  ���ɻ���0~2*pi
              u=u+1;
          end
    end
end
