function [imwarped, x_min,x_max,y_min,y_max,alpha]= warpImage(movingIm,H)
[m,n,~]=size(movingIm);
A = [1 1 1;1,m,1;n,m,1;n,1,1];
A = A';
%%
corners = H*A;
corners(1,:) = corners(1,:)./corners(3,:);
corners(2,:) = corners(2,:)./corners(3,:);
x_min = min(corners(1,:));
x_min = floor(x_min);
x_max = max(corners(1,:));
x_max = ceil(x_max);
y_min = min(corners(2,:));
y_min = floor(y_min);
y_max = max(corners(2,:));
y_max = ceil(y_max);
x=x_min:1:x_max;
y=y_min:1:y_max;
[Xq_tra,Yq_tra] = meshgrid(x,y);
after_tras_cor_arr = [Xq_tra(:)';Yq_tra(:)';ones(1,numel(Yq_tra))];%%
source_cor_arr = H\after_tras_cor_arr;%%原图像需要插值的坐标
Xq = source_cor_arr(1,:);
Yq = source_cor_arr(2,:);
Xq = reshape(Xq,[numel(y),numel(x)]);
Yq = reshape(Yq,[numel(y),numel(x)]);
[X,Y] = meshgrid(1:n,1:m);
imwarped(:,:,1) = interp2(X,Y,movingIm(:,:,1),Xq ,Yq);%%
imwarped(:,:,2) = interp2(X,Y,movingIm(:,:,2),Xq ,Yq);%%
imwarped(:,:,3) = interp2(X,Y,movingIm(:,:,3),Xq ,Yq);%%
%%
alpha = isnan(imwarped(:,:,1))&isnan(imwarped(:,:,2))&isnan(imwarped(:,:,3));
alpha = 1-alpha;
end