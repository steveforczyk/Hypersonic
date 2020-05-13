function R = xyz2wgs(S)

% XYZ2WGS  Converts cartesian coordinates (x,y,z) into
%          ellipsoidal coordinates (lat,lon,alt) on WGS-84
%          according to a non iterative method (Bowring 76,
%          see also GPS Theory and Practice, p. 258).
%
% Input:
%   S = nx4 matrix with time, X, Y, Z
%   A! first column of S is time but can be dummy.
%
% Output:
%   R = nx4 matrix with time, lon (lam), lat (phi), elevation
%       (lon,lat in decimal degrees, elevation in meters above ellipsoid)
%
% Call: R = xyz2wgs(S)
%
% eric.calais@ens.fr

% semimajor axis axis and flattening for WGS-84
a = 6378137.0000;
f = 1.0/298.257223563;
% semiminor axis (should be 6356752.3142);
b = a * (1-f); 
% eccentricity
ecc = 2*f - f^2;

% second numerical eccentricity
e1 = (a^2-b^2)/b^2;

% read data
t = S(:,1);
x = S(:,2);
y = S(:,3);
z = S(:,4);

% auxiliary quantities
p = sqrt(x.^2+y.^2);
theta = atan2(z.*a,p*b);

% longitude
lam = atan2(y,x);

% latitude
phi = atan2(z + (sin(theta)).^3*e1*b , p - (cos(theta)).^3*ecc^2*a);

% radius of curvature in prime vertical
N = a ./ sqrt(1-(sin(phi)).^2.*ecc);
%N = a / sqrt((cos(phi)).^2*a^2 + (sin(phi)).^2*b^2);

% geocentric (?) altitude
alt_g = (p ./ cos(phi)) - N;

% ellipsoidal altitude
alt = p.*cos(phi) + z.*sin(phi) - a.*sqrt(1.0 - ecc.*sin(phi).^2);

% fill out result matrix
R = [t lam*180.0/pi phi*180.0/pi alt];
