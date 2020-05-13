% Copyright Ashish Tewari (c) 2006
function [p,Vi,Vf]=lambert(mu,Ri,Rf,t)
ri=norm(Ri); rf=norm(Rf);
q=dot([0;0;1],cross(Ri,Rf));
phi=acos(dot(Ri,Rf)/(ri*rf)) 
if q<0
    phi=2*pi-phi
end
A=sqrt(ri*rf/(1-cos(phi)))*sin(phi);
z=0.01;
n=1;
[C,S]=stumpff(z,5);
y=ri+rf-A*(1-z*S)/sqrt(C);
x=sqrt(y/C);
tc=(x^3*S+A*sqrt(y))/sqrt(mu);
while abs(t-tc)>1e-9
    fx=A*sqrt(C)*x+S*x^3-t*sqrt(mu);
    fxp=A*sqrt(C)+3*S*x^2;
    dx=-fx/fxp;
    x=x+dx;
    n=n+1;
    y=C*x*x;
    tc=(x^3*S+A*sqrt(y))/sqrt(mu);
    z=(1-sqrt(C)*(ri+rf-y)/A)/S;
    [C,S]=stumpff(z,20);
end
p=ri*rf*(1-cos(phi))/y;
f=1-y/ri;
g=A*sqrt(y/mu);
gd=1-y/rf;
Vi=(Rf-f*Ri)/g;
Vf=(gd*Rf-Ri)/g;    