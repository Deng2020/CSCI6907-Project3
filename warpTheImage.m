
function [imgout]=warpTheImage(H,img1,img2)
tform = maketform('projective',H');
img21 = imtransform(img2,tform); % reproject img2


% 
[M1 N1 dim] = size(img1);
[M2 N2 dimk1] = size(img2);%%´ý±ä»»¾ØÕó


% do the mosaic
pt = zeros(3,4);
pt(:,1) = H*[1;1;1];
pt(:,2) = H*[N2;1;1];
pt(:,3) = H*[N2;M2;1];
pt(:,4) = H*[1;M2;1];
x2 = pt(1,:)./pt(3,:);
y2 = pt(2,:)./pt(3,:);

up = round(min(y2));
Yoffset = 0;
if up <= 0
	Yoffset = -up+1;
	up = 1;
end

left = round(min(x2));
Xoffset = 0;
if left<=0
	Xoffset = -left+1;
	left = 1;
end

[M3 N3 dimk2] = size(img21);

rowBegin=max(up,Yoffset+1); %overlap Area
columnBegin=max(left,Xoffset+1);
rowEnd=min(up+M3-1,Yoffset+M1);
columnEnd=min(left+N3-1,Xoffset+N1);
imgout(up:up+M3-1,left:left+N3-1,:) = img21;

overlapAreaP2=imgout(rowBegin:rowEnd,columnBegin:columnEnd,:);%pixel values of overlap area from P2

% img1 is above img21
imgout(Yoffset+1:Yoffset+M1,Xoffset+1:Xoffset+N1,:) = img1;
overlapAreaP1=imgout(rowBegin:rowEnd,columnBegin:columnEnd,:);


 overlapArea=imgout(rowBegin:rowEnd,columnBegin:columnEnd);
 [overRowLength,overColumnLength]=size(overlapArea);%overlap Row and Column length
 distFromBound1OneLine=(overColumnLength-1:-1:0);%this is just one line
 distFromBound1=repmat(distFromBound1OneLine,overRowLength,1);  %Replicate and tile it to the size of the overlapArea. Because the same column has the same distance to the boundary
 distFromBound2OneLine=(0:overColumnLength-1);
 distFromBound2=repmat(distFromBound2OneLine,overRowLength,1);%this the dist from boundary 2

 % blending
%  blendingImg(:,:,:)=(overlapAreaP2(:,:,:).*distFromBound2+overlapAreaP1(:,:,:).*distFromBound1)/(overColumnLength-1);
% imshow(blending)
overlapAreaP2=double(overlapAreaP2);
overlapAreaP1=double(overlapAreaP1);
blendingImg=zeros(overRowLength,overColumnLength,3);

for i=1:3
blendingImg(:,:,i)=(overlapAreaP2(:,:,i).*distFromBound2+overlapAreaP1(:,:,i).*distFromBound1)/(overColumnLength-1);
end
blendingImg=uint8(blendingImg);

% imshow(blendingImg);title('after blending');
 imgout(rowBegin:rowEnd,columnBegin:columnEnd,:)=blendingImg;
end