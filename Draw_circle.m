function Draw_circle(centery, centerx, reference, r)
radius = reference + r;
angle = 0:0.01:2*pi; 
d_x = radius*cos(angle);
d_y = radius*sin(angle); 
hold on
plot(centery, centerx, 'g+')
for i=1:size(centery,1)
        plot(centery(i)+d_y, centerx(i)+d_x, 'y');
end
end