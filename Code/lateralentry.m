% Copyright Ashish Tewari (c) 2006
function xdot= lateralentry(t,x)
global dtr; global mu; global S; global b; global m; global rm; global omega;     
global Jxx; global Jyy; global Cnb; global Cyb; global Cnr; global Cyr; global Clp;
global CD; global v0; global Th0; global Psi0; global lat0;
[g,gn]=gravity(x(1),x(2)); 
chi = Psi0;
cfpa=cos(Th0);sfpa=sin(Th0);
cchi = cos(chi); schi = sin(chi);
cla=cos(lat0);sla=sin(lat0); 
if x(1)<rm
    x(1)=rm;
end
alt = x(1) - rm;
v  = x(2);
atmosp = atmosphere(alt, v, b);
rho = atmosp(2); 
q = 0.5*rho*v^2;
mach = atmosp(3);
[t alt v mach]
Xfo=-q*S*CD;
raddot = v*sfpa;  
veldot=-g*sfpa +gn*cchi*cfpa + Xfo/m...
        +omega*omega*x(1)*cla*(sfpa*cla-cfpa*cchi*sla);
betadot=-x(7)+v*cfpa^2*cchi*tan(lat0)*x(3)/x(1)...
        +2*omega*cla*sfpa*schi*x(3)...
        +g*x(4)*cfpa/v+gn*(x(4)*sfpa*cchi-x(6)*cchi)...
        +q*S*(Cyb*x(3)+b*Cyr*x(7)/(2*v))/(m*v);
phidot=x(5)+x(7)*tan(Th0);
Pdot=q*S*b^2*Clp*x(5)/(2*Jxx*v);
psidot=x(7)/cfpa;
Rdot=q*S*b*(Cnb*x(3)+b*Cnr*x(7)/(2*v))/Jyy;
xdot=[raddot; veldot; betadot; phidot; Pdot; psidot; Rdot];