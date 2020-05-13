function [x,y,z] = wgs2xyz(lam,phi,h)

% WGS2XYZ   Converts lam(longitude) phi(latitude) ellipsoidal coordinates
%           from WGS-84 to ECEF cartesian coordinates. Vectorized.
%
% Input:  lam (longitude), phi (latitude), h can be vectors
%         lon, lat in decimal degrees
%         h in meters above ellipsoid
%
% Output: x,y,z in meters
%
% Call: [x,y,z] = wgs2xyz(longitude,latitude,h)
%
% eric.calais@ens.fr

% semimajor axis axis and flattening for WGS-84
a = 6378137.0000;
f = 1.0/298.257223563;
% semiminor axis (should be 6356752.3142);
b = a * (1-f);
% eccentricity
ecc = 2*f - f^2;

% degrees to radians
lam = lam.*pi/180;
phi = phi.*pi/180;

% radius of curvature in prime vertical
N = a ./ sqrt(1-(sin(phi)).^2.*ecc);
%N = a^2 / sqrt((cos(phi)).^2*a^2 + (sin(phi)).^2*b^2);

% make sure all are column vectors
lam = lam(:); phi = phi(:); h = h(:);
N = N(:);

x = cos(phi).*cos(lam).*(N+h);
y = cos(phi).*sin(lam).*(N+h);
z = sin(phi).*(N.*(b^2/a^2) + h);

