function T = tform(tri1,tri2)
  %
  % compute the transformation T which maps points
  % of triangle1 to triangle2 
  %
  %  tri1 : 2x3 matrix containing coordinates of triangle 1
  %  tri2 : 2x3 matrix containing coordinates of triangle 2
  %
  %  T : the resulting transformation, should be a 3x3
  %      matrix which operates on points described in 
  %      homogeneous coordinates 
  %
  def = [tri2(2,1), tri2(2,2), tri2(2,3)]*inv([tri1(1,1), tri1(1,2), tri1(1,3); tri1(2,1), tri1(2,2), tri1(2,3);1, 1, 1]);
  abc = [tri2(1,1), tri2(1,2), tri2(1,3)]*inv([tri1(1,1), tri1(1,2), tri1(1,3); tri1(2,1), tri1(2,2), tri1(2,3);1, 1, 1]);
  T = [abc;def;0,0,1];
end