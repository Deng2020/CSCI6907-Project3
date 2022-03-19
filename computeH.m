function H = computeH(im1_pts,im2_pts)
%%使用最小二乘法估计H 矩阵,im1_pt为动点，im2_pts为不动点
numpoint = size(im1_pts,1);
A = zeros(numpoint*3,8);
y = zeros(numpoint*3,1);
for index=1:numpoint
    A(3*(index-1)+1,1) = im1_pts(index,1);
    A(3*(index-1)+1,2) = im1_pts(index,2);
    A(3*(index-1)+1,3) = 1;
    A(3*(index-1)+2,4) = im1_pts(index,1);
    A(3*(index-1)+2,5) = im1_pts(index,2);
    A(3*(index-1)+2,6) = 1;
    A(3*(index-1)+3,7) = im1_pts(index,1);
    A(3*(index-1)+3,8) = im1_pts(index,2);
    A(3*(index-1)+3,9) = 1;
    y(3*(index-1)+1)=im2_pts(index,1);
    y(3*(index-1)+2)=im2_pts(index,2);
    y(3*(index-1)+3)=1;
end
H = inv(A'*A)*A'*y;
H(1:8) = H(1:8)/H(9);
H(9)=1;
H = reshape(H,[3,3]);
H = H';
end