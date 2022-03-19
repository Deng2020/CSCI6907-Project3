%2张图像同时显示。以显示特征点匹配连线

function im = appendimages(image1, image2)


rows1 = size(image1,1);
rows2 = size(image2,1);

if (rows1 < rows2)
     image1(rows2,1) = 0;
else
     image2(rows1,1) = 0;
end


im = cat(2,image1,image2);   
