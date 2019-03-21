function []=Get_Local_img(MeanPos,bow_angle,length,width)

width=width/2; %½¢¿í

Bow_x=MeanPos(1,1);
Bow_y=MeanPos(2,1);

Tail_x=MeanPos(1,1)+length*cos(bow_angle);
Tail_y=MeanPos(2,1)-length*sin(bow_angle);
%Local_img=gray(MeanPos_y(1)-n/4*sin(MeanThea):MeanPos_y(1)+10*sin(MeanThea),MeanPos_x(1)-10*cos(MeanThea):MeanPos_x(1)+n/4*cos(MeanThea));

    %Bow A- B  
BowA_x=round(Bow_x+width*cos(pi/2+bow_angle)); 
BowA_y=round(Bow_y-width*sin(pi/2+bow_angle));

BowB_x=round(Bow_x-width*cos(pi/2+bow_angle));
BowB_y=round(Bow_y+width*sin(pi/2+bow_angle));
    %Tail A- B 
TailA_x=round(Tail_x+width*cos(pi/2+bow_angle));
TailA_y=round(Tail_y-width*sin(pi/2+bow_angle));

TailB_x=round(Tail_x-width*cos(pi/2+bow_angle));
TailB_y=round(Tail_y+width*sin(pi/2+bow_angle));

hold on
plot([BowA_x,BowB_x,TailB_x,TailA_x,BowA_x],[BowA_y,BowB_y,TailB_y,TailA_y,BowA_y],'r','LineWidth',0.3)
