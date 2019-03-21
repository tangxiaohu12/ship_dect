function [R,Circle_bw]=Model(M)
%**********************************R************************************%
             
Circle_bw=zeros(M,M);
c=[M/2 M/2];   % Բ����뾶
r=M/2;
Circle_bw(c(1),c(2))=1;
Circle_bw=bwdist(Circle_bw)<r;%  ����ŷʽ���� ���Բ1
%*******������ȷ��ߵ�б��
theta=(0:1/8:1)*pi; 
x=r*cos(theta)+M/2;
y=r*sin(theta)+M/2;
k=(y-(M/2)*ones(1,length(y)))./(x-(M/2)*ones(1,length(x)));  %б��k 0~-0
%b=50-25*k;
for l =1:16 
    R(:,:,l)=zeros(M,M);
end

%**************1/4�������еĵȷ�***********%
for l=1:4    
    for i=1:M/2
        for j=1:M
       
        ak=(i-M/2)/(j-M/2);   %���������Բ�ĵ��ֱ��б��ע��˴�������ı仯���൱���ڵ������޵�x y ����
        if ak>k(l)&&ak<k(l+1)  % �Ż�   kΪ����ʱ�Ĵ���
            R(i,j,l)=Circle_bw(i,j);
        end    
    
        end
    end
    %figure,imshow(R(:,:,l),'InitialMagnification','fit')
end
%**************ʣ�µľ�Ϊ��ת***********%
for q=5:8 
      R(:,:,q)=rot90(R(:,:,q-4),-1);%kȡ��Ϊ˳ʱ��
  %  figure,imshow(R(:,:,q),'InitialMagnification','fit')
end
for p=9:16 
      R(:,:,p)=rot90(R(:,:,p-8),2);
   % figure,imshow(R(:,:,p),'InitialMagnification','fit')
end

%*********************************R*******************************%