% Copyright Ashish Tewari (c) 2006
function xdot = pitchup(t,x)
global S; global c; global m; global Jyy; global rm; global omega; 
global v0; global phi0; global A0; global Q0; global Cma; global Cmad;
global Cmq; global Cxu; global Cxa; global Czu; global Cza; global Czad;
global Czq;  
delta=x(6)
alt = x(1)
[g,gn]=gravity(alt+rm,delta); 
v  = v0*(1+x(2));
atmosp = atmosphere(alt, v, c);
rho = atmosp(2);
q = 0.5*rho*v^2;
mach = atmosp(3);
CL=m*g/(q*S);
[t alt v mach]
phi=x(4)-x(3); 
hdot=v*sin(phi);
udot = -Q0+q*S*(Cxu*x(2)+Cxa*x(3)...
     +phi*(-cos(phi0)*CL+sin(phi0)*sin(A0)*m*gn/(q*S)))/(m*v0);
alphadot = (2*x(2)*omega*cos(delta)*sin(A0)...
     +2*x(2)*v0/(rm+alt)+x(2)*Q0+x(5)+q*S*(Czu*x(2)+Cza*x(3)...
     +phi*(sin(phi0)*CL-cos(phi0)*cos(A0)*m*gn/(q*S))...
     +c*Czq*x(5)/(2*v0))/(m*v0))/(1-q*S*c*Czad/(2*m*v0^2));
thetadot = x(5);   
Qdot = q*S*c*(Cma*x(3)+c*(Cmad*alphadot+Cmq*x(5))/(2*v0))/Jyy;
deltadot=v*cos(phi)*cos(A0)/(rm+alt);
xdot = [hdot; udot; alphadot; thetadot; Qdot; deltadot];