% Copyright Ashish Tewari (c) 2006
function [r,v]=relative(orb1,orb2,t)
mu=398600.4; 
a=orb1(1);e=orb1(2);i=orb1(3);w=orb1(4);Om=orb1(5);tau=orb1(6);
n=sqrt(mu/a^3);
M=-n*tau;
E=kepler(e,M);
r0=a*(1-e*cos(E));
R0=a*[cos(E)-e;sqrt(1-e^2)*sin(E);0];
V0=sqrt(mu*a)*[-sin(E);sqrt(1-e^2)*cos(E);0]/r0;
[Rt,Vt]=trajE(mu,0,R0,V0,t);
C=rotation(i,Om,w);
Rt=C*Rt;
Vt=C*Vt;
a=orb2(1);e=orb2(2);i=orb2(3);w=orb2(4);Om=orb2(5);tau=orb2(6);
n=sqrt(mu/a^3);
M=-n*tau;
E=kepler(e,M);
r0=a*(1-e*cos(E));
R0=a*[cos(E)-e;sqrt(1-e^2)*sin(E);0];
V0=sqrt(mu*a)*[-sin(E);sqrt(1-e^2)*cos(E);0]/r0;
[R,V]=trajE(mu,0,R0,V0,t);
C=rotation(i,Om,w);
R=C*R;
V=C*V;
r=R-Rt;
v=V-Vt;
rt=norm(Rt);
lat=asin(dot(Rt,[0;0;1])/rt);
slon=dot(Rt,[0;1;0])/(rt*cos(lat));
clon=dot(Rt,[1;0;0])/(rt*cos(lat));
long=atan(slon/clon);
if slon<0 && clon>0
    long=asin(slon);
elseif slon>0 && clon<0
    long=acos(clon);
end
CLH=INtoLH(lat,long);
r=CLH*r;
v=CLH*v;