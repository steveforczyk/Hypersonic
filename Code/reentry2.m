function Y = reentry2(t,o)
% Copyright Ashish Tewari (c) 2006
% Modified By Stephen Forczyk to change m to objm
global dtr;
global mu;
global S;
global c;
global objm;     
global rm; 
global omega;
global Gamma;    
global f8; 
m=objm;
[g,gn]=gravity(o(3),o(2)); 
lo = o(1);
la = o(2);
clo = cos(lo);
slo = sin(lo);
cla = cos(la);
sla = sin(la);
fpa = o(5);
chi = o(6);
cfpa = cos(fpa); 
sfpa = sin(fpa);
cchi = cos(chi);
schi = sin(chi); 
if o(3)<rm
    o(3)=rm;
end
alt = o(3) - rm;
v  = o(4);
atmosp = atmosphere(alt, v, c);
rho = atmosp(2); 
Qinf = 0.5*rho*v^2;
mach = atmosp(3);
%[t alt v mach];% screen disp statement
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
    CD = CDC + (CDFM - CDC)*(0.333*log10(Kn/sin(pi/6))+0.5113);
end
Xfo=-Qinf*S*CD;
Qdot=Qinf*v*S*CD/20; 
longidot = o(4)*cfpa*schi/(o(3)*cla); 
latidot =  o(4)*cfpa*cchi/o(3);       
raddot = o(4)*sfpa;                    
veldot = -g*sfpa +gn*cchi*cfpa+Xfo/m...
       +omega*omega*o(3)*cla*(sfpa*cla-cfpa*cchi*sla);
gammadot = (o(4)/o(3) - g/o(4))*cfpa-gn*cchi*sfpa/o(4)...
       + 2*omega*schi*cla+ omega*omega*o(3)*cla*(cfpa*cla...
       + sfpa*cchi*sla)/o(4); 
headdot = o(4)*schi*tan(o(2))*cfpa/o(3)-gn*schi/o(4)...
        - 2*omega*(tan(o(5))*cchi*cla - sla)...
        + omega*omega*o(3)*schi*sla*cla/(o(4)*cfpa); 
Y = [longidot; latidot; raddot;...
 veldot; gammadot; headdot]; % time derivatives
% dispstr=strcat('t=',num2str(t),'-longidot-',num2str(longidot),'-alt-',num2str(alt));
% disp(dispstr)
ab=1;
if alt<=120e3
    fprintf(f8,'\t%1.5e\t%1.5e\t%1.5e\t%1.5e\t%1.5e\t%1.5e\n',alt,CD,mach,veldot,Qinf,Qdot);
end