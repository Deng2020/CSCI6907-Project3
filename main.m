clear all;
close all;
img1 = imread('result.jpg');
img2 = imread('yosemite3.jpg');
fixedIm=double(img1);
movingIm=double(img2);
im = appendimages(img1, img2);
figure;imshow(im,[]);hold on;
[x,y] = ginput(12);
plot(x,y,'r*');
fixedpoint = [x(1:2:end),y(1:2:end)];
movingpoint = [x(2:2:end),y(2:2:end)];
fixedpoint = round(fixedpoint);
movingpoint = round(movingpoint);
for index=1:size(fixedpoint,1)
    movingImPatch = im(movingpoint(index,2)-5:movingpoint(index,2)+5,movingpoint(index,1)-5:movingpoint(index,1)+5);
    fixedImPatch = im(fixedpoint(index,2)-5:fixedpoint(index,2)+5,fixedpoint(index,1)-5:fixedpoint(index,1)+5);
    moving = cpcorr ([6,6],[6,6],movingImPatch,fixedImPatch);
    movingpoint(index,:) = [moving(1)+movingpoint(index,1)-6,moving(2)+movingpoint(index,2)-6];
end

for index=1:size(fixedpoint,1)
    plot([fixedpoint(index,1),movingpoint(index,1)],[fixedpoint(index,2),movingpoint(index,2)],'--r*');
end
hold off;
%%
im1_pts = movingpoint;
im1_pts(:,1) = im1_pts(:,1)-size(img1,2);
im2_pts = fixedpoint;

%%
H = computeH(im1_pts,im2_pts);

 [imwarped, x_min,x_max,y_min,y_max,alpha]= warpImage(movingIm,H); 
 figure;imshow(uint8(imwarped))
title('image wraped')
imgout1 = blendImage(fixedIm,imwarped,x_min,y_min,alpha);
imgout2 = blendImageusingdistFromBound(fixedIm,imwarped,x_min,y_min,alpha);
 figure;
 subplot(1,3,1);imshow(uint8(fixedIm));title('fixed image');
  subplot(1,3,2);imshow(uint8(movingIm));title('moving image');
 subplot(1,3,3);imshow(uint8(imgout2));title('image blend');
 
 figure;
 imshow(uint8(imgout1));title('blend image using alpha channel');
 
  figure;
 imshow(uint8(imgout2));title('blend image using distanc to image boundary');
 
 imwrite(uint8(imgout2),'result.jpg');
 figure;
 imshow(uint8(fixedIm));
  figure;
 imshow(uint8(movingIm));
 