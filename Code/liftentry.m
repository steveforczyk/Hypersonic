% Copyright Ashish Tewari (c) 2006
function Y = liftentry(t,o)
global dtr; global mu; global S; global c; global m; global rm;       
global omega; global Gamma;    
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
atmosp = atmosphere(alt, v, c);
rho = atmosp(2); 
Qinf = 0.5*rho*v^2;
mach = atmosp(3);
[t alt v mach]
Kn=atmosp(4);
CDC=conticap(mach);
s = mach*sqrt(Gamma/2);
CDFM=1.75+sqrt(pi)/(2*s);
iflow=atmosp(6);
if iflow==2
    CD=CDC;
elseif iflow==1
    CD=CDFM;
else
    CD=CDC+(CDFM-CDC)*(0.333*log10(Kn/sin(pi/6))+0.5113);
end
CL=0.5*CD;
if t>=450 && t<=500
   bank=pi/2;
   %bank=0;
elseif t>500 && t<=550
    bank=-pi/2;
    %bank=0;
else
    bank=0;
end
Xfo=-Qinf*S*CD;
Zfo=Qinf*S*CL*cos(bank);
Yfo=Qinf*S*CL*sin(bank);;
longidot = o(4)*cfpa*schi/(o(3)*cla); 
latidot =  o(4)*cfpa*cchi/o(3); 
raddot = o(4)*sfpa;   
veldot =-g*sfpa +gn*cchi*cfpa + Xfo/m+...
       omega*omega*o(3)*cla*(sfpa*cla-cfpa*cchi*sla);
gammadot=(o(4)/o(3)-g/o(4))*cfpa-gn*cchi*sfpa/o(4)+...
          Zfo/(o(4)*m) + 2*omega*schi*cla...
          + omega*omega*o(3)*cla*(cfpa*cla...
          + sfpa*cchi*sla)/o(4);
headdot=o(4)*schi*tan(o(2))*cfpa/o(3)-gn*schi/o(4)...
          - Yfo/(o(4)*cfpa*m)...
          - 2*omega*(tan(o(5))*cchi*cla - sla)...
          +omega*omega*o(3)*schi*sla*cla/(o(4)*cfpa);
Y = [longidot ; latidot ; raddot ;...
        veldot ; gammadot ; headdot ];
if alt<=120e3
Qdot=Qinf*v*S*CD/10;
transacc=v*sqrt(gammadot^2+headdot^2);
fprintf(f8,'\t%1.5e\t%1.5e\t%1.5e\t%1.5e\t%1.5e\t%1.5e\n',alt,mach,veldot,transacc,Qinf,Qdot);
end