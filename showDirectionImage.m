function showDirectionImage(dImg,cmap)
%showDirectionImage 显示角度图像,从0~179度用不同颜色表示不同角度
%   dImg: 角度图像矩阵,角度可以是弧度或度
%   cmap: colormp
if max(dImg(:))<pi %如果dImg为弧度,转换为角度
    dImg=(dImg/pi)*180;
end
if ~isa(dImg,'uint8')%转换为uint8
    dImg=uint8(dImg);
end

m=size(cmap,1);
indx=floor(linspace(1,m,180));%等间隔去cmap中的180个颜色作为显示的colormap
omap=cmap(indx,:);
% show(dImg,omap),colorbar;
figure('name',inputname(1)),imshow(dImg,omap,'InitialMagnification','fit'),colorbar;
axis on;


