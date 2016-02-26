%
  % morphing script
  %

  clc
  clear
  load julia.mat
  base_points = base_points';
  input_points = input_points';
  % load in two images...
  I1 = imread('peter.jpg');
  I2 = imread('julia.jpg');
  
  % get user clicks on keypoints

  % generate triangulation 


  % now produce the frames of the morph sequenceA
  for fnum = 1:61
    t = (fnum-1)/61;
    pts_target = (1-t)*input_points + t*base_points;                % intermediate key-point locations
    I1_warp = warp1(I1,input_points,pts_target,tri1);              % warp image 1
    I2_warp = warp1(I2,base_points,pts_target,tri1);                                          % warp image 2
    Iresult = uint8((1-t)*I1_warp + t*I2_warp);                     % blend the two warped images
    imwrite(Iresult,sprintf('frame_%2.2d.jpg',fnum),'jpg')
  end