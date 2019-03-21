function [object_length,object_width,length_error,width_error]=CacuObj_L_W(bw,position,bow_angle)
length_error=0;
width_error =0;
count_up=0;
count_down=0;
[Position_F_R,Rotated_img,Rotated_img_Row,Rotated_img_Col]=img_rotation(bw,[position(1),position(2)],180*bow_angle/pi,1);%舰首点从原图映射 到 变换后的图
X0=Position_F_R(1);
Y0=Position_F_R(2);
%% object_width
old_width=0;
next_width=0;
width=0;
Zero_count=0;
for Xi=X0:X0+100
    for Yi=Y0:Y0+80
        try T=Rotated_img(Yi,Xi)
        catch ErrorInfo %捕获到的错误是一个MException对象 
            disp(ErrorInfo);
            width_error=1;
            break;
        end
        if Rotated_img(Yi,Xi)==255
            count_up=count_up+1;
        else
            
            break;
        end  
    end
    for Yi=Y0:Y0+80
%         if (2*Y0-Yi)<=0
%              width_error=1;
%              break;
%         end
        try T=Rotated_img(2*Y0-Yi,Xi)     
        catch ErrorInfo %捕获到的错误是一个MException对象 
            disp(ErrorInfo);
            width_error=1;
             break;
        end
        if Rotated_img(2*Y0-Yi,Xi)==255 %Y0-(Yi-Y0)
            count_down=count_down+1;
        else
            break;
        end
    end
    next_width=abs(count_up+count_down);
    count_up=0;
    count_down=0;
    if abs(next_width-old_width)<=20
        if (next_width-old_width)==0  %排除单独点的情况
            Zero_count=Zero_count+1;
        end
        old_width=next_width; 
    else
        width=old_width;
        if Xi-X0<7         %经验值
            width_error=1;
        end
        if width<=25
            width=48;
        end
        break;
    end
    if Xi==X0+99
        width=old_width;
        if width>=100
            width_error=1;
        end
        if width<=20
            width=48;
        end
    end
    if Zero_count>=80
        width_error=1;
    end
end
object_width = width+6;   
%% object_length
W=object_width/2-2;
D=15;
Zero_count_L=0;
for Xi=X0:X0+499
    if Xi+2*D+16==Rotated_img_Col-1                                                         %边界保护
        length_error=1;
        break;
    end
   
    BlockA=Rotated_img(Y0-W:Y0+W-1,Xi:Xi+D);
    BlockB=Rotated_img(Y0-W:Y0+W-1,Xi+D+6:Xi+2*D+16);
    Sum_sectorA=sum(BlockA(:))/255;
    Sum_sectorB=sum(BlockB(:))/255;
    if Sum_sectorA>=W*D && Sum_sectorB<=1/8*W*D
        forward_map_px2=Xi+D;
        forward_map_py2=Y0;
        if forward_map_px2<=X0+width
            length_error=1;  
        end
        if forward_map_px2<=X0+2*width                                                  %这里会出bug
       % length_error=1;
            forward_map_px2=X0+6*object_width;
            forward_map_py2=Y0;
        end
        break;
    elseif Xi==X0+499                                                                  %虚警与检测率的平衡，按理应该length_error=1;
            forward_map_px2=X0+6*object_width;
            forward_map_py2=Y0;
            %length_error=1;
            break;
        
    else
        forward_map_px2=X0+6*object_width;
        forward_map_py2=Y0;
        %length_error=1;
    end
    
%     if Sum_sectorA==0 && Sum_sectorB==0
%         Zero_count_L=Zero_count_L+1;
%         length_error=1;
%         if Zero_count_L>3*D                                                             %这个值给小会少筛。
%            
%            forward_map_px2=X0+6*object_width;
%            forward_map_py2=Y0;
%             try Block2=Rotated_img(Y0-W:Y0+W-1,X0:X0+5*object_width);                   %计算框中的像素和值
%             catch ErrorInfo 
%                 disp(ErrorInfo);
%                 break;
%             end     
%            if sum(Block2(:))/255<3/10*object_width*5*object_width
%                length_error=1;
%            end
%            break;
%         end
%     end
end
if length_error==0
    [Position_F_R,Rotated_img]=img_rotation(bw,[forward_map_px2,forward_map_py2],180*bow_angle/pi,-1);%舰尾点从变换后的图映射到原图
    object_length=sqrt((Position_F_R(1)-position(1))^2+(Position_F_R(2)-position(2))^2);
else
    object_length=0;
end