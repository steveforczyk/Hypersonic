% Copyright Ashish Tewari (c) 2006
function deriv = accelclimb(t,o)
global dtr; global mu; global omega; global S; global c;           
global rm; global b; global CLmax; global sweep;
global f8;
[g,gn]=gravity(o(3),o(2)); 
lo = o(1);la = o(2);
clo = cos(lo); slo = sin(lo);
cla = cos(la); sla = sin(la);
fpa = o(5); chi = o(6);
cfpa = cos(fpa); sfpa = sin(fpa);
cchi = cos(chi); schi = sin(chi); 
if o(3)<rm
    o(3)=rm;
end
alt = o(3) - rm;
v  = o(4);
atmosp = atmosphere(alt,v,c);
rho = atmosp(2); 
Qinf = 0.5*rho*v^2;
mach = atmosp(3);
[fT,tsfc]=engine(alt,mach);
fT=2*fT;
m=o(7);
CD0=parasite(mach);
CL=m*g*cfpa/(Qinf*S);
if CL>CLmax
    CL=0
end
K=liftddf(mach,CL,sweep,b^2/S);
[t alt mach CL]
if alt<=b
    Keff=K*33*(alt/b)^1.5/(1+33*(alt/b)^1.5);
else
    Keff=K;
end
CD=CD0+Keff*CL^2;
D=Qinf*S*CD;
L=Qinf*S*CL;
Xfo = fT-D;
Zfo = L;
Yfo = 0;
fprintf(f8,'\t%1.5e\t%1.5e\t%1.5e\t%1.5e\t%1.5e\n',...
          t,alt,CL,mach,Qinf);
longidot = o(4)*cfpa*schi/(o(3)*cla); 
latidot =  o(4)*cfpa*cchi/o(3); 
raddot = o(4)*sfpa;   
veldot = -g*sfpa +gn*cchi*cfpa + Xfo/m...
       +omega*omega*o(3)*cla*(sfpa*cla-cfpa*cchi*sla);
gammadot=o(4)/o(3)-g/o(4))*cfpa-gn*cchi*sfpa/o(4)...
        +Zfo/(o(4)*m)+ 2*omega*schi*cla...
        + omega*omega*o(3)*cla*(cfpa*cla...
        + sfpa*cchi*sla)/o(4);
headdot = o(4)*schi*tan(o(2))*cfpa/o(3)...
        -gn*schi/o(4)-Yfo/(o(4)*cfpa*m)...
        - 2*omega*(tan(o(5))*cchi*cla - sla)...
        + omega*omega*o(3)*schi*sla*cla/(o(4)*cfpa);
mdot=-tsfc*fT/(9.8*3600);
deriv = [longidot; latidot; raddot; veldot; gammadot; headdot; mdot];