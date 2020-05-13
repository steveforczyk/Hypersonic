% Copyright Ashish Tewari (c) 2006
function deriv = takeoff(t,o)
global dtr; global mu; global omega; global S; global c; global rm;      
global CD0; global K; global b; global CLmax; global CLG; 
global fT0; global tsfc0; global mur;
[g,gn]=gravity(o(3),o(2)); 
lo = o(1);la = o(2);
clo = cos(lo); slo = sin(lo);
cla = cos(la); sla = sin(la);
fpa = o(5); chi = o(6);
cfpa = cos(fpa); sfpa = sin(fpa);
cchi = cos(chi); schi = sin(chi);
if o(3)<rm+3
    o(3)=rm+3;
end
alt = o(3) - rm;
v  = o(4);
atmosp = atmosphere(alt,v,c);
rho = atmosp(2); 
machb = atmosp(3);
[t alt v]
Qinf = 0.5*rho*v^2;
if alt<=b
    Keff=K*33*(alt/b)^1.5/(1+33*(alt/b)^1.5);
else
    Keff=K;
end
m=o(7);
vstall=sqrt(2*m*g/(1.2249*S*CLmax));
if v<=vstall
fT=fT0-0.1*fT0*v/vstall;
tsfc=tsfc0+0.1*tsfc0*v/vstall;
else
    fT=0.9*fT0;
    tsfc=1.1*tsfc0;
end
if v<1.2*vstall
    CL=CLG;
else
    CL=0.8*CLmax;  
end
CD=CD0+Keff*CL^2;
D=Qinf*S*CD;
L=Qinf*S*CL;
if alt==3
    Xfo = fT-D-mur*(m*g-L);
else
    Xfo = fT*rho/1.2249-D;
end
Zfo = L;
Yfo = 0;
longidot = o(4)*cfpa*schi/(o(3)*cla); 
latidot =  o(4)*cfpa*cchi/o(3); 
raddot = o(4)*sfpa;   
veldot=-g*sfpa+gn*cchi*cfpa...
   +Xfo/m+omega*omega*o(3)*cla*(sfpa*cla-cfpa*cchi*sla);
if v<1.2*vstall && alt==3 
    gammadot=0;
    headdot=0;
else
gammadot=(o(4)/o(3)-g/o(4))*cfpa-gn*cchi*sfpa/o(4)...
        +Zfo/(o(4)*m)+2*omega*schi*cla...
        +omega*omega*o(3)*cla*(cfpa*cla...
        +sfpa*cchi*sla)/o(4);
headdot =o(4)*schi*tan(o(2))*cfpa/o(3)...
        -gn*schi/o(4)-Yfo/(o(4)*cfpa*m)...
        - 2*omega*(tan(o(5))*cchi*cla-sla)...
        +omega*omega*o(3)*schi*sla*cla/(o(4)*cfpa);
end
mdot=-tsfc*fT/(9.8*3600);
deriv=[longidot;latidot;raddot;veldot;gammadot;headdot;mdot];