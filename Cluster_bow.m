%*****该函数用于将检测到的显著性角点归类******%
%*****一个舰首可能存在多个显著性角点这些点大多是相邻的故本方法利用连通域标记的方法进行聚类*****%
function [MeanPos,dim]=Cluster_bow(Cluster_img,CorPosition_x,CorPosition_y,CorThea)
N = size(CorPosition_x,2);
for i=1:N                                           %形成一幅反应显著性角点分布的二值图，角点处为1
    Cluster_img(CorPosition_y(i),CorPosition_x(i))=1;
end

%SE = strel('disk',5);
%open_Cluster_img = imdilate(Cluster_img,SE);            %膨胀

imLabel = bwlabel(Cluster_img,8);                     %对各连通域进行标记，
L=reshape(imLabel,1,[]);                            

max_value=max(L);
for i=1:max_value(1)
    [r,c]=find(imLabel==i);
    for k=1:size(c)
        relvate_index=find(CorPosition_x==c(k,1));  %找出列坐标对应在原数组的索引 对应多个
        for j=1:size(relvate_index)
            if CorPosition_y(relvate_index(j))==r(k,1);
                index=relvate_index(j);
            end
        end
        theta(k)=CorThea(index);
    end
    mean_theta=mean(theta);
    MeanPos(:,i)=[round(mean(c)),round(mean(r)),mean_theta];
    r=0;
    c=0;
    theta=0;
end
dim =size(MeanPos,2);