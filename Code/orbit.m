% Copyright Ashish Tewari (c) 2006
function [r,v]=orbit(mu,orb,t)
a=orb(1);e=orb(2);i=orb(3);w=orb(4);Om=orb(5);tau=orb(6);
n=sqrt(mu/a^3);
M=-n*tau;
E=kepler(e,M);
r0=a*(1-e*cos(E));
R0=a*[cos(E)-e;sqrt(1-e^2)*sin(E);0];
V0=sqrt(mu*a)*[-sin(E);sqrt(1-e^2)*cos(E);0]/r0;
[R,V]=trajE(mu,0,R0,V0,t);
if abs(i)>=1e-6
C=rotation(i,Om,w);
else
    C=eye(3);
end
r=C*R;
v=C*V;