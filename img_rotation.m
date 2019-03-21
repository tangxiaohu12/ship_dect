
%**************ͨ��ͼ����ת�仯���ڶ�ͼ����к�������*****************%
function [Position_F_R,Rotation_img,new_m,new_n]=img_rotation(bw,position,degree,flag)
[m, n] = size(bw);%��Ҫ�õ���ת��ͼ��Ĵ�С����ԭͼ���Ϊm����Ϊn
new_m = ceil(abs(m*cosd(degree)) + abs(n*sind(degree)));
new_n = ceil(abs(n*cosd(degree)) + abs(m*sind(degree)));%ԭ��ʽΪ����
%% forward mapping   
% forward mapping matrices
if flag==1 %ǰ��ӳ��
    Rotation_img= imrotate(bw,-degree,'bilinear');
%     figure;
%     imshow(Rotation_img);
%     title('˳ʱ����ת');
    m1 = [1 0 0; 0 -1 0; -0.5*n 0.5*m 1];
    m2 = [cosd(degree) -sind(degree) 0; sind(degree) cosd(degree) 0; 0 0 1];
    m3 = [1 0 0; 0 -1 0; 0.5*new_n 0.5*new_m 1]; 
    new_coordinate = [position(1) position(2) 1]*m1*m2*m3;
    forward_map_position = round(new_coordinate);
    Position_F_R=forward_map_position;
end
%% reverse mapping
if flag==-1%����ӳ��
    % reverse mapping matrices
    rm1 = [1 0 0; 0 -1 0; -0.5*new_n 0.5*new_m 1];
    rm2 = [cosd(degree) sind(degree) 0; -sind(degree) cosd(degree) 0; 0 0 1];
    rm3 = [1 0 0; 0 -1 0; 0.5*n 0.5*m 1];
    old_coordinate = [position(1) position(2) 1]*rm1*rm2*rm3;
    reverse_map_position = round(old_coordinate);
    Position_F_R=reverse_map_position;
    Rotation_img=bw;
end
