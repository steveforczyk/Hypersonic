% Copyright Ashish Tewari (c) 2006
function xdot=perturb(t,x)
global mu;
global mu3;
global orb;
R=x(1:3,1); 
r=norm(R);
xdot(1:3,1)=x(4:6,1);
[R3,V3]=orbit(mu,orb,t); 
ad=disturb(mu3,R,R3); 
xdot(4:6,1)=-mu*R/r^3+ad;