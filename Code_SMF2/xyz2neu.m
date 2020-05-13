function NEU = xyz2neu(O,V)

% XYZ2NEU	Convert ECEF into local topocentric
%		Call: NEU = xyz2neu(O,V)
%		O = origin vector in ECEF frame (meters), or n x 3 matrix
%		V = position or velocity vector in ECEF frame (m or m/yr), or n x 3 matrix
%		Note that O can be the same as V
%		NEU  = position or velocity vector in NEU frame (m or m/yr), or n x 3 matrix

% initialize variables
X = V(:,1); Y = V(:,2); Z = V(:,3);
NEU = [];

% if O is a single point, make it the same size as V
if (size(O,1) == 1)
  XR = ones(size(V,1),1) .* O(1);  
  YR = ones(size(V,1),1) .* O(2);  
  ZR = ones(size(V,1),1) .* O(3);  
else
  XR = O(:,1); YR = O(:,2); ZR = O(:,3);
end
T = zeros(size(XR,1),1);

% convert origin vector to ellipsoidal coordinates then to in radians
E = xyz2wgs([T XR YR ZR]);
E(:,2) = E(:,2).*pi/180; % longitude
E(:,3) = E(:,3).*pi/180; % latitude

% compute sines and cosines
cp = cos(E(:,2)); sp = sin(E(:,2)); % longitude = phi
cl = cos(E(:,3)); sl = sin(E(:,3)); % latitude = lam

for i=1:size(V,1)
  % build the rotation matrix
  R = [ -sl(i)*cp(i)   -sl(i)*sp(i)    cl(i);
         -sp(i)            cp(i)           0;
         cl(i)*cp(i)    cl(i)*sp(i)    sl(i)];

  % apply the rotation
  NEUi = R * [X(i);Y(i);Z(i)];

  % increment result matrix NEU
  NEU = [NEU;NEUi'];
end

