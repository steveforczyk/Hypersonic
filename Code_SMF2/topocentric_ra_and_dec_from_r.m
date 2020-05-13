
function [ra dec rho]=topocentric_ra_and_dec_from_r(r,lla,t);
 

% Geocentric Coordinates (ECI) to   Topocentric equatorial  system
%{  
  This function calculates the Topocentric equatorial  system 
  right ascension and the  declination from the geocentric 
  equatorial position vector
  r       - position vector in meters
  t       - Universal Coordinated Time i.e . [2017 02 02 11 48 28]; 
  lla     - Latitude, longitude, altitude (LLA) coordinates M-by-3 array
            degrees and meters 
  ra      - Topocentric right ascension (degrees)
  dec     - Topocentric declination (degrees)
%}
% ----------------------------------------------

%Rsite = lla2eci(lla,t);

%lla=[phi lamda H];

deg = pi/180;
km=1/1000;

f      = 1/298.256421867;
phi=lla(1)*deg;
lamda=lla(2);
H=lla(3)*km;
j0=juliandate([t(1) t(2) t(3)]);
j = (j0 - 2451545)/36525;

g0 = 100.4606184 + 36000.77004*j + 0.000387933*j^2 - 2.583e-8*j^3;

if (g0 >= 360)
    g0 = g0 - fix(g0/360)*360;
elseif (g0 < 0)
    g0 = g0 - (fix(g0/360) - 1)*360;
end

ut=t(4)+t(5)/60+t(6)/3600;
gst = g0 + 360.98564724*ut/24;
theta = gst + lamda;

theta = theta - 360*fix(theta/360);

theta=theta*deg;

Re     = 6378.13655;
Rsite = [(Re/sqrt(1-(2*f - f*f)*sin(phi)^2) + H)*cos(phi)*cos(theta), ...
         (Re/sqrt(1-(2*f - f*f)*sin(phi)^2) + H)*cos(phi)*sin(theta), ...
         (Re*(1 - f)^2/sqrt(1-(2*f - f*f)*sin(phi)^2) + H)*sin(phi)]




rho=r*km-Rsite;

l = rho(1)/norm(rho);
m = rho(2)/norm(rho);
n = rho(3)/norm(rho);

dec = asind(n);

if m > 0
    ra = acosd(l/cosd(dec));
else
    ra = 360 - acosd(l/cosd(dec));
end

rho=norm(rho);