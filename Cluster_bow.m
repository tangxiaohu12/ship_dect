%*****�ú������ڽ���⵽�������Խǵ����******%
%*****һ�����׿��ܴ��ڶ�������Խǵ���Щ���������ڵĹʱ�����������ͨ���ǵķ������о���*****%
function [MeanPos,dim]=Cluster_bow(Cluster_img,CorPosition_x,CorPosition_y,CorThea)
N = size(CorPosition_x,2);
for i=1:N                                           %�γ�һ����Ӧ�����Խǵ�ֲ��Ķ�ֵͼ���ǵ㴦Ϊ1
    Cluster_img(CorPosition_y(i),CorPosition_x(i))=1;
end

%SE = strel('disk',5);
%open_Cluster_img = imdilate(Cluster_img,SE);            %����

imLabel = bwlabel(Cluster_img,8);                     %�Ը���ͨ����б�ǣ�
L=reshape(imLabel,1,[]);                            

max_value=max(L);
for i=1:max_value(1)
    [r,c]=find(imLabel==i);
    for k=1:size(c)
        relvate_index=find(CorPosition_x==c(k,1));  %�ҳ��������Ӧ��ԭ��������� ��Ӧ���
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