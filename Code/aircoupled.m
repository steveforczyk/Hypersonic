% Copyright Ashish Tewari (c) 2006
function xdot=aircoupled(t,x) 
global dtr; global S; global c; global b; global lt; global m; global rm;      
global omega; global Jxx; global Jyy; global Jzz; global Jxz; global v0;
global phi0; global A0; global Q0; global delta; global h0; global Cma;
global c2vCmad; global c2vCmq; global Cxu; global Cxa; global Czu;
global Cza; global c2vCzad; global c2vCzq; global Cyb; global Cnb;
global Clb; global Cnr; global Cnp; global Clp; global Clr; global Cyr;
[g,gn]=gravity(h0+rm,delta); 
v  = v0*(1+x(9));
atmosp = atmosphere(h0, v, c);
rho = atmosp(2); 
q = 0.5*rho*v^2;
mach = atmosp(3);
CL=m*g/(q*S);
[t v mach]
udot = -Q0+q*S*(Cxu*x(9)+Cxa*x(7)...
     +x(5)*(-cos(phi0)*CL+sin(phi0)*sin(A0)*m*gn/(q*S)))/(m*v0);
alphadot = (2*x(9)*omega*cos(delta)*sin(A0)...
     +2*x(9)*v0/(rm+h0)+x(9)*Q0+x(2)+q*S*(Czu*x(9)+Cza*x(7)...
     +x(5)*(sin(phi0)*CL-cos(phi0)*cos(A0)*m*gn/(q*S))...
     +c2vCzq*x(2))/(m*v0))/(1-q*S*c2vCzad/(m*v0));
L=q*S*b*(Clb*x(8)+0.5*b*(Clp*x(1)+Clr*x(3))/v);
M=q*S*c*(Cma*x(7)+c2vCmq*x(2)+c2vCmad*alphadot);
N=q*S*b*(Cnb*x(8)+0.5*b*(Cnp*x(1)+Cnr*x(3))/v);
jxz=Jxx*Jzz-Jxz^2;
P=x(1);Q=x(2);R=x(3);
pdot=(Jxz*(Jzz+Jxx-Jyy)*P*Q-(Jxz^2+Jzz*(Jzz-Jyy))*Q*R+Jxz*N+Jzz*L)/jxz;
qdot=(Jxz*(R^2-P^2)+(Jzz-Jxx)*P*R+M)/Jyy;
rdot=(Jxz*(pdot-Q*R)+(Jxx-Jyy)*P*Q+N)/Jzz;
phidot=x(1)+(x(2)*sin(x(4))+x(3)*cos(x(4)))/cos(x(5));
thetadot=x(2)*cos(x(4))-x(3)*sin(x(4));
psidot=(x(2)*sin(x(4))+x(3)*cos(x(4)))/cos(x(5));
betadot=-x(3)+v*cos(phi0)^2*cos(A0)*tan(delta)*x(8)/(rm+h0)...
        +2*omega*cos(delta)*sin(phi0)*sin(A0)*x(8)...
        +g*x(4)*cos(phi0)/v+gn*(x(4)*sin(phi0)*cos(A0)-x(6)*cos(A0))...
        +q*S*(Cyb*x(8)+b*Cyr*x(3)/(2*v))/(m*v);
xdot=[pdot;qdot;rdot;phidot;thetadot;psidot;alphadot;betadot;udot];