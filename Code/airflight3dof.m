% Copyright Ashish Tewari (c) 2006
function xdot = airflight3dof(t,x)
global dtr; global S; global c; global rm; global omega; global CD0;
global K; global qmax; global Mmax; global CL; global fT0;
global tsfc0; global mfinal; global f8;
[g,gn]=gravity(x(3),x(2)); 
lo = x(1);la = x(2);
clo = cos(lo); slo = sin(lo);
cla = cos(la); sla = sin(la);
fpa = x(5); chi = x(6);
cfpa = cos(fpa); sfpa = sin(fpa);
cchi = cos(chi); schi = sin(chi); 
if x(3)<rm
    x(3)=rm;
end
alt = x(3) - rm; 
v  = x(4); 
atmosp = atmosphere(alt,v,c);
rho = atmosp(2);  
mach = atmosp(3); 
Qinf = 0.5*rho*v^2;
if Qinf>=qmax || mach>=Mmax
    fT=fT0*0.85;
    tsfc=tsfc0*0.95;
else
    fT=fT0;
    tsfc=tsfc0;
end
m=x(7);
if m<=mfinal
    fT=0;
end
CD=CD0+K*CL^2;
D=Qinf*S*CD;
Xfo = fT*rho/0.3663-D;
Yfo = 0;
Zfo = Qinf*S*CL;
fprintf(f8,'\t%1.5e\t%1.5e\t%1.5e\t%1.5e\t%1.5e\n',...
                alt, mach, Qinf, Xfo, Yfo);
longidot= x(4)*cfpa*schi/(x(3)*cla); 
latidot=  x(4)*cfpa*cchi/x(3);       
raddot= x(4)*sfpa;             
veldot= -g*sfpa+gn*cchi*cfpa+Xfo/m+...
      omega*omega*x(3)*cla*(sfpa*cla-cfpa*cchi*sla);
gammadot=(x(4)/x(3)-g/x(4))*cfpa-gn*cchi*sfpa/x(4)...
        +Zfo/(x(4)*m)+2*omega*schi*cla...
     +omega*omega*x(3)*cla*(cfpa*cla+sfpa*cchi*sla)/x(4);
headdot=x(4)*schi*tan(x(2))*cfpa/x(3)-gn*schi/x(4)...
     -Yfo/(x(4)*cfpa*m)-2*omega*(tan(x(5))*cchi*cla-sla)...
    +omega*omega*x(3)*schi*sla*cla/(x(4)*cfpa);
mdot=-tsfc*fT/(9.8*3600);
xdot=[longidot;latidot;raddot;veldot;gammadot;headdot;mdot];