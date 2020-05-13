% Copyright Ashish Tewari (c) 2006
function deriv = rocket(t,o)
global dtr mu omega S c rm; 
global tb1 tb2 fT1 fT2 m01 m02; 
global mL mp1 mp2 Gamma f8; 
global mass drag mach Qdot D Qinf; 
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
if v<0
    v=0;
end
Gamma=o(5,1);
if alt<=2000e3
	atmosp = atmosphere(alt,v,c);
	rho = atmosp(2);
    Qinf = 0.5*rho*v^2;
	mach = atmosp(3);
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
    	CD =CDC+(CDFM-CDC)*(0.333*log10(Kn/sin(pi/6))+0.5113);
	end
else
    rho=0;
    Qinf=0;
    CD=0;
    mach=0;
end
if t<=tb1 
    fT=fT1;
    m=m01-mp1*t/tb1;
    CD=8*CD;
elseif t<=(tb1+tb2)
    fT=fT2;
    m=m02-mp2*(t-tb1)/tb2;
    CD=3*CD;
else
    fT=0;
    m=mL;
end
mass=m;
[t alt mass mach];
D=Qinf*S*CD;
Xfo = fT-D;
Yfo = 0;
Zfo = 0;
longidot = o(4)*cfpa*schi/(o(3)*cla); 
latidot =  o(4)*cfpa*cchi/o(3); 
raddot = o(4)*sfpa;  
veldot = -g*sfpa +gn*cchi*cfpa + Xfo/m...
         +omega*omega*o(3)*cla*(sfpa*cla-cfpa*cchi*sla);
if t<=10
    headdot=0; gammadot=0;
else
    gammadot=(o(4)/o(3)-g/o(4))*cfpa-gn*cchi*sfpa/o(4)...
        +Zfo/(o(4)*m)+2*omega*schi*cla...
        +omega*omega*o(3)*cla*(cfpa*cla+ sfpa*cchi*sla)/o(4);
    if abs(cfpa)>1e-6
        headdot=o(4)*schi*tan(o(2))*cfpa/o(3)-gn*schi/o(4)-Yfo/(o(4)*cfpa*m)...
        	-2*omega*(tan(o(5))*cchi*cla - sla)...
        	+omega*omega*o(3)*schi*sla*cla/(o(4)*cfpa);
    else
        headdot=0;
    end
end
deriv = [longidot; latidot; raddot; veldot; gammadot; headdot];
if alt<=120e3
    Qdot=Qinf*v*S*CD/20;
fprintf(f8,'\t%1.5e\t%1.5e\t%1.5e\t%1.5e\t%1.5e\t%1.5e\t%1.5e\n',...
		 t,alt,m,mach,veldot,Qinf,Qdot);
end