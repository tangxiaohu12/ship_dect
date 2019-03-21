function [Reverse_Pxy]=Reverse_map(bw,Rotation_img,position,degree)

[new_m,new_n]=size(Rotation_img);
[m,n]=size(bw);
 % reverse mapping matrices
 rm1 = [1 0 0; 0 -1 0; -0.5*new_n 0.5*new_m 1];
 rm2 = [cosd(degree) sind(degree) 0; -sind(degree) cosd(degree) 0; 0 0 1];
 rm3 = [1 0 0; 0 -1 0; 0.5*n 0.5*m 1];
 old_coordinate = [position(1) position(2) 1]*rm1*rm2*rm3;
 Reverse_Pxy = round(old_coordinate);
 