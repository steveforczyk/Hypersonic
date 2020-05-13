% Copyright Ashish Tewari (c) 2006
function [gc,gnorth]=gravity(r,lat)
phi=pi/2-lat;
mu=3.986004e14;
Re=6378.135e3;
J2=1.08263e-3;
J3=2.532153e-7;
J4=1.6109876e-7;
gc=mu*(1-1.5*J2*(3*cos(phi)^2-1)*(Re/r)^2-2*J3*cos(phi)...
    *(5*cos(phi)^2-3)*(Re/r)^3-(5/8)*J4*(35*cos(phi)^4-30*cos(phi)^2+3)*(Re/r)^4)/r^2;
gnorth=-3*mu*sin(phi)*cos(phi)*(Re/r)*(Re/r)*(J2+0.5*J3*(5*cos(phi)^2-1)...
    *(Re/r)/cos(phi)+(5/6)*J4*(7*cos(phi)^2-1)*(Re/r)^2)/r^2;
    
