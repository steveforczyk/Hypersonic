% Copyright Ashish Tewari (c) 2006
function deriv = supmaneuver(t,o)
global dtr;global mu;global omega;global S;global c;global rm;    
global b;global CLmax;global sweep;global n;     
global f8;    
[g,gn]=gravity(o(3),o(2)); 
lo = o(1);la = o(2);
clo = cos(lo); slo = sin(lo); cla = cos(la); sla = sin(la);
fpa = o(5); chi = o(6);
cfpa = cos(fpa); sfpa = sin(fpa); cchi = cos(chi); schi = sin(chi); 
if o(3)<rm
    o(3)=rm;
end
alt = o(3) - rm;
v=o(4);
m=o(7);
atmosp = atmosphere(alt,v,c);
rho = atmosp(2); 
mach = atmosp(3);
if mach<0
    mach=0;
elseif mach>2
    mach=2;
end
Qinf = 0.5*rho*v^2;
[fT,tsfc]=engine(alt,mach);
fT=2*fT;
CD0=parasite(mach);
vc=sqrt(2*n*m*g/(rho*S*CLmax)); 
if v>=vc
    nb=n;
    epsilon=13.5*dtr;
    CL=n*(m*g-fT*sin(epsilon))/(Qinf*S);
    if CL>CLmax
    CL=CLmax;
    epsilon=0;
    end
else
    CL=CLmax;
    epsilon=32*dtr;
    nb=Qinf*S*CLmax/(m*g-fT*sin(epsilon));
    if nb>n
    nb=n;
    epsilon=0;
    end
end
if nb>1
bankb=acos(1/nb);
else
    bankb=0;
end
K=liftddf(mach,CL,sweep,b^2/S);
if alt<=b
    Keff=K*33*(alt/b)^1.5/(1+33*(alt/b)^1.5);
else
    Keff=K;
end
CD=CD0+Keff*CL^2;
D=Qinf*S*CD; L=Qinf*S*CL;
Xfo = fT*cos(epsilon)-D; Zfo = fT*sin(epsilon)+L*cos(bankb);
Yfo = L*sin(bankb);
longidot = v*cfpa*schi/(o(3)*cla); 
latidot =  v*cfpa*cchi/o(3); 
raddot = v*sfpa;  %Radius 
veldot = -g*sfpa +gn*cchi*cfpa + Xfo/m...
       + omega*omega*o(3)*cla*(sfpa*cla-cfpa*cchi*sla);
gammadot = (v/o(3)-g/v)*cfpa-gn*cchi*sfpa/v...
        + Zfo/(v*m) + 2*omega*schi*cla...
        + omega*omega*o(3)*cla*(cfpa*cla + sfpa*cchi*sla)/v;
headdot = v*schi*tan(o(2))*cfpa/o(3)-gn*schi/v...
        - Yfo/(v*cfpa*m)- 2*omega*(tan(o(5))*cchi*cla - sla)...
        + omega*omega*o(3)*schi*sla*cla/(v*cfpa);
mdot=-tsfc*fT/(9.8*3600);
fprintf(f8,'\t%1.5e\t%1.5e\t%1.5e\t%1.5e\t%1.5e\n',t,CL,mach,nb,headdot);
deriv = [longidot; latidot; raddot; veldot; gammadot; headdot; mdot];