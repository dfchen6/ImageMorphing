function I_target = warp(I_source,pts_source,pts_target,tri)
%
% I_source : color source image  (HxWx3)
% pts_source : coordinates of keypoints in the source image  (2xN)
% pts_target : coordinates of where the keypoints end up after the warp (2xN)
% tri : list of triangles (triples of indices into pts_source)  (Kx3)
%       for example, the coordinates of the Tth triangle should be 
%       given by the expression:
%
%           pts_source(:,tri(T,:))
% 
%
% I_target : resulting warped image, same size as source image (HxWx3)
%
[h,w,d] = size(I_source);
num_tri = size(tri,1)

% coordinates of pixels in target image in 
% homogenous coordinates.  we will assume 
% target image is same size as source
[xx,yy] = meshgrid(1:w,1:h);
Xtarg = [xx(:) yy(:) ones(h*w,1)]';

% for each triangle, compute tranformation which
% maps it to from the target back to the source
T = zeros(3,3,num_tri); % tranformation matricies
for i=1:num_tri
      n = tri(i,:);
      n1 = n(1);
      n2 = n(2);
      n3 = n(3);
      tri1 = [pts_source(:,n1), pts_source(:,n2), pts_source(:,n3)];
      tri2 = [pts_target(:,n1), pts_target(:,n2), pts_target(:,n3)];
      T(:,:,i) = tform(tri2,tri1);
end

% for each pixel in the target image, figure
% out what triangle it lives in so we know 
% what transformation to apply
tindex = mytsearch(pts_target(1,:),pts_target(2,:),tri,Xtarg(1,:),Xtarg(2,:));

% now tranform target pixels back to 
% source image
Xsrc = zeros(size(Xtarg));
for t = 1:num_tri
% find source coordinates for all target pixels
% lying in triangle t
temp = find(tindex==t);
num = size(temp,2);
for kk=1:num
Xsrc(:,temp(kk)) = T(:,:,t)*Xtarg(:,temp(kk));
end
end

% now we know where each point in the target 
% image came from in the source, we can interpolate
% to figure out the colors

assert(size(I_source,3) == 3)  % we only are going to deal with color images

R_target = interp2(double(I_source(:,:,1)),Xsrc(1,:),Xsrc(2,:));
G_target = interp2(double(I_source(:,:,2)),Xsrc(1,:),Xsrc(2,:));
B_target = interp2(double(I_source(:,:,3)),Xsrc(1,:),Xsrc(2,:));

I_target1 = reshape(R_target,h,w);
I_target2 = reshape(G_target,h,w);
I_target3 = reshape(B_target,h,w);

I_target1(isnan(I_target1))=0;
I_target2(isnan(I_target2))=0;
I_target3(isnan(I_target3))=0;

I_target(:,:,1) = I_target1;
I_target(:,:,2) = I_target2;
I_target(:,:,3) = I_target3;
end

