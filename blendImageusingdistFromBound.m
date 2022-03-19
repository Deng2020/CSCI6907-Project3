function imgout = blendImageusingdistFromBound(fixedIm,movingIm_trans,xmin,ymin,alpha)

 [M3 N3 dim] = size(movingIm_trans);
 [M1 N1 dimk2] = size(fixedIm);
 map1 = zeros(M3,N3);
 center_x = round((N3+1)/2);
 center_y = round((M3+1)/2);
 map1(center_x,center_y)=1;
 bwdist1 = bwdist(map1);
 bwdist1(center_y,center_x)=eps;
 bwdist1(alpha==0) = 1e9;
 %%
 map2 = zeros(M1,N1);
 center_x = round((N1+1)/2);
 center_y = round((M1+1)/2);
 map2(center_x,center_y)=1;
 bwdist2 = bwdist(map2);
 bwdist2(center_y,center_x)=eps;

 
 %%
 
Yoffset = 0;
if ymin <= 0
	Yoffset = -ymin+1;
	ymin = 1;
end
Xoffset = 0;
if xmin<=0
	Xoffset = -xmin+1;
	xmin = 1;
end



rowBegin=max(ymin,Yoffset+1); %overlap Area
columnBegin=max(xmin,Xoffset+1);
rowEnd=min(ymin+M3-1,Yoffset+M1);
columnEnd=min(xmin+N3-1,Xoffset+N1);
imgout(ymin:ymin+M3-1,xmin:xmin+N3-1,:) = movingIm_trans;
distMap(ymin:ymin+M3-1,xmin:xmin+N3-1) = bwdist1;
overlapAreadistP2 = distMap(rowBegin:rowEnd,columnBegin:columnEnd,:);%pixel values of overlap area from P2
overlapAreaP2=imgout(rowBegin:rowEnd,columnBegin:columnEnd,:);%pixel values of overlap area from P2
% fixedIm is above img21
imgout(Yoffset+1:Yoffset+M1,Xoffset+1:Xoffset+N1,:) = fixedIm;
overlapAreaP1=imgout(rowBegin:rowEnd,columnBegin:columnEnd,:);
distMap(Yoffset+1:Yoffset+M1,Xoffset+1:Xoffset+N1) = bwdist2;
overlapAreadistP1 = distMap(rowBegin:rowEnd,columnBegin:columnEnd,:);%pixel values of overlap area from P2
%%
 overlapArea=imgout(rowBegin:rowEnd,columnBegin:columnEnd);
 [overRowLength,overColumnLength]=size(overlapArea);%overlap Row and Column length
 distFromBound1OneLine=(overColumnLength-1:-1:0);%this is just one line
 distFromBound1=repmat(distFromBound1OneLine,overRowLength,1);  %Replicate and tile it to the size of the overlapArea. Because the same column has the same distance to the boundary
 distFromBound2OneLine=(0:overColumnLength-1);
 distFromBound2=repmat(distFromBound2OneLine,overRowLength,1);%this the dist from boundary 2

 % blending
 
% imshow(blending)
overlapAreaP2=double(overlapAreaP2);
overlapAreaP1=double(overlapAreaP1);
blendingImg=zeros(overRowLength,overColumnLength,3);
overlapAreaP2(isnan(overlapAreaP2)) =0;

% for i=1:3
% blendingImg(:,:,i)=(overlapAreaP2(:,:,i).*overlapAreadistP1+overlapAreaP1(:,:,i).*overlapAreadistP2)./(overlapAreadistP1+overlapAreadistP2);
% end

for i=1:3
blendingImg(:,:,i)=(overlapAreaP2(:,:,i).*distFromBound2+overlapAreaP1(:,:,i).*distFromBound1)/(overColumnLength-1);
end
blendingImg=uint8(blendingImg);

% imshow(blendingImg);title('after blending');
 imgout(rowBegin:rowEnd,columnBegin:columnEnd,:)=blendingImg;
end