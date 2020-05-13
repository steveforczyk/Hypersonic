function   [r,v]=rv_from_observe(rho,rhodot,A,Adot,a,...
    adot,theta,phi,H)

%   wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww

%This   function   calculates   the   geocentric   equatorial   position   and velocity   vectors   
%of   an   object   from   radar   observations   of   range, azimuth,   elevation   angle   and   
%their   rates.

%deg          -   conversion   factor   between   degrees   and   radians pi             -   
%3.1415926...
%Re             -   equatorial   radius   of   the   earth   (km) f                -   earth’s   
%flattening   factor
%wE             -   angular   velocity   of   the   earth   (rad/s)
%omega     -   earth’s   angular   velocity   vector   (rad/s)   in   the geocentric   equatorial   
%frame
%theta     -   local   sidereal   time   (degrees)   of   tracking   site phi          -   geodetic  
% latitude   (degrees)   of   site
%H                -   elevation   of   site   (km)
%R                -   geocentric   equatorial   position   vector   (km)   of   tracking   site Rdot 
%       -   inertial   velocity   (km/s)   of   site
%rho          -   slant   range   of   object   (km) rhodot   -   range   rate   (km/s)
%A                -   azimuth   (degrees)   of   object   relative   to   observation   site Adot    
%    -   time   rate   of   change   of   azimuth   (degrees/s)

global   f   Re   wE;
deg = pi/180;

omega  = [0   0   wE];

%...Convert   angular   quantities   from   degrees   to   radians:
A  =A*deg;

Adot=Adot*deg;

a =a*deg; 
adot =adot*deg; 
theta = theta*deg;
phi=  phi*deg;

%...Equation   5.56:

R = [(Re/sqrt(1-(2*f   -   f*f)*sin(phi)^2)   +   H)*cos(phi)*cos(theta),...
    (Re/sqrt(1-(2*f   -   f*f)*sin(phi)^2)   +   H)*cos(phi)*sin(theta),...
     (Re*(1   -   f)^2/sqrt(1-(2*f   -   f*f)*sin(phi)^2)   +   H)*sin(phi)];
%...Equation  5.66:
Rdot= cross(omega,R);
%...Equation  5.83a:
dec= asin(cos(phi)*cos(A)*cos(a)  +  sin(phi)*sin(a));
%...Equation  5.83b:

h = acos((cos(phi)*sin(a)  -  sin(phi)*cos(A)*cos(a))/cos(dec));
if  ((A  >  0)  &&  (A  <  pi))
    h =2*pi  -  h;
end




end