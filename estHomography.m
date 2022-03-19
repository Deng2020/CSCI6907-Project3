function [f  inlierIdx] = estHomography( img1,img2,x,y)
ransacCoef.minPtNum = 4;
ransacCoef.iterNum = 1500;
ransacCoef.thDist = 3;
ransacCoef.thInlrRatio = .1;

minPtNum = ransacCoef.minPtNum;
iterNum = ransacCoef.iterNum;
thInlrRatio = ransacCoef.thInlrRatio;
thDist = ransacCoef.thDist;
ptNum = size(x,2);
thInlr = round(thInlrRatio*ptNum);

inlrNum = zeros(1,iterNum);
fLib = cell(1,iterNum);

for p = 1:iterNum
	% 1. repeated sample  4 points 
	sampleIdx = randIndex(ptNum,minPtNum);
	%2 compute a homography from the points
    f1 = solveHomo(x(:,sampleIdx),y(:,sampleIdx));
	
	% 3 map all points using homography and calculate the distance
	dist =  calcDist(f1,x,y);
	inlier1 = find(dist < thDist);
	inlrNum(p) = length(inlier1);
	if length(inlier1) < thInlr, continue; end
	% 4 compute  a least squares using All the inliers ,if its inlier
	% ration is bigger than threshold Inlier
    fLib{p} =solveHomo(x(:,inlier1),y(:,inlier1));
end

%5 find the Homography with the most outlier
[val1,idx] = max(inlrNum);
f = fLib{idx};
dist =  calcDist(f,x,y);
inlierIdx = find(dist < thDist);

% Create a new image showing the two images side by side.
img3 = appendimages(img1,img2);

% Show a figure with lines joining the accepted matches.
figure('Position', [100 100 size(img3,2) size(img3,1)]);
colormap('gray');
imagesc(img3);
hold on;
cols1 = size(img1,2);
fprintf('after using RANSAC  %d matches left.\n',size(inlierIdx,2) );
for i = 1: size(inlierIdx,2)
line([y(1,inlierIdx(i))  x(1,inlierIdx(i))+cols1], ...
    [y(2,inlierIdx(i)) x(2,inlierIdx(i))], 'Color', 'c'); 
   
end

hold off;

end

