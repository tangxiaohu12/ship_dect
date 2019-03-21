function [CorPosition_x,CorPosition_y,CorThea]=Sample_Cor(posx,posy,thea,bw)

Radius=5;
Mask = zeros(2*Radius,2*Radius);
c = [Radius Radius];   % Բ����뾶
Mask(c(1),c(2)) = 1;
Mask=bwdist(Mask) < Radius;%  ����ŷʽ���� ���Բ1

Length=14;%ǰ��
Length2=50; %½�ؼ��
u=1;
v=1;
hold on
for i=1:size(thea,2)
    SampPos_A_x(u)=round(posx(i)+Length*cos(thea(i)));
    SampPos_A_y(u)=round(posy(i)-Length*sin(thea(i)));
    
    %½�ػ򺣲��� ��ʱ�뷽���
    SampPos_B_x(u)=round(posx(i)+Length2*cos(pi/3+thea(i)));
    SampPos_B_y(u)=round(posy(i)-Length2*sin(pi/3+thea(i)));
    
    %ǰ������ - +
    SampPos_C_x(u)=round(posx(i)+Length*cos(pi+thea(i)));
    SampPos_C_y(u)=round(posy(i)-Length*sin(pi+thea(i)));
    
    %½�ػ򺣲��� ˳ʱ�뷽���
    SampPos_D_x(u)=round(posx(i)+Length2*cos(thea(i)-pi/3));
    SampPos_D_y(u)=round(posy(i)-Length2*sin(thea(i)-pi/3));
    plot([posx(i)+Length*cos(thea(i)),posx(i)+Length2*cos(pi/3+thea(i)),posx(i)+Length*cos(pi+thea(i)),posx(i)+Length2*cos(thea(i)-pi/3),posx(i)+Length*cos(thea(i))],[posy(i)-Length*sin(thea(i)),posy(i)-Length2*sin(pi/3+thea(i)),posy(i)-Length*sin(thea(i)+pi),posy(i)-Length2*sin(thea(i)-pi/3),posy(i)-Length*sin(thea(i))],'y:','LineWidth',1.75);
   %%
    try
        Block1=bw(SampPos_C_y(u)-Radius:SampPos_C_y(u)+Radius-1,SampPos_C_x(u)-Radius:SampPos_C_x(u)+Radius-1);
    catch ErrorInfo                                                                  %���񵽵Ĵ�����һ��MException���� 
        disp(ErrorInfo);
        break;
    end
    try
        Block4=bw(SampPos_A_y(u)-Radius:SampPos_A_y(u)+Radius-1,SampPos_A_x(u)-Radius:SampPos_A_x(u)+Radius-1);
    catch ErrorInfo                                                                  %���񵽵Ĵ�����һ��MException���� 
        disp(ErrorInfo);
        break;
    end
    %%
    Circle_Sector1=Block1.*Mask;  %ǰ��
    Circle_Sector4=Block4.*Mask;  %����
    if sum(Circle_Sector1(:))==0&&sum(Circle_Sector4(:))>=4*Radius*Radius*pi/5
    %%
        try
            Block2=bw(SampPos_B_y(u)-Radius:SampPos_B_y(u)+Radius-1,SampPos_B_x(u)-Radius:SampPos_B_x(u)+Radius-1);
        catch ErrorInfo                                                                  %���񵽵Ĵ�����һ��MException���� 
            disp(ErrorInfo);
            break
        end
        
        try
            Block3=bw(SampPos_D_y(u)-Radius:SampPos_D_y(u)+Radius-1,SampPos_D_x(u)-Radius:SampPos_D_x(u)+Radius-1);
        catch ErrorInfo                                                                  %���񵽵Ĵ�����һ��MException���� 
            disp(ErrorInfo);
            break
        end   
        %%
        Circle_Sector2=Block2.*Mask;
        Circle_Sector3=Block3.*Mask;
        if (sum(Circle_Sector2(:))==0&&sum(Circle_Sector3(:))>=4*Radius*Radius*pi/5)||(sum(Circle_Sector3(:))==0&&sum(Circle_Sector2(:))>=4*Radius*Radius*pi/5)
            CorPosition_x(v)=posx(i);
            CorPosition_y(v)=posy(i);
            CorThea(v)=thea(i);
            v=v+1;
        end
    end   
    u=u+1;
end