count=0;
LEFT=1;
XISP1=250.;
XISP2=250.;
XMF1=.85;
XMF2=.85;
WPAY=100.;
DELV=20000.;
DELV1=.3333*DELV;
DELV2=.6667*DELV;
AMAX1=10.;
AMAX2=10.;

GAMDEG=85.;
TOP2=WPAY*(exp(DELV2/(XISP2*32.2))-1.);
BOT2=1/XMF2-((1.-XMF2)/XMF2)*exp(DELV2/(XISP2*32.2));
WP2=TOP2/BOT2;
WS2=WP2*(1-XMF2)/XMF2;
WTOT2=WP2+WS2+WPAY;
TRST2=AMAX2*(WPAY+WS2);
TB2=XISP2*WP2/TRST2;
TOP1=WTOT2*(exp(DELV1/(XISP1*32.2))-1.);
BOT1=1/XMF1-((1.-XMF1)/XMF1)*exp(DELV1/(XISP1*32.2));
WP1=TOP1/BOT1;
WS1=WP1*(1-XMF1)/XMF1;
WTOT=WP1+WS1+WTOT2;
TRST1=AMAX1*(WTOT2+WS1);
TB1=XISP1*WP1/TRST1;
DELVK=DELV/1000.;
H=.01;
T=0.;
S=0.;
A=2.0926e7;
GM=1.4077e16;
ALTNM=0.;
ALT=ALTNM*6076.;
ANGDEG=90.;
ANG=ANGDEG/57.3;
if LEFT==1
	VRX=cos(1.5708-GAMDEG/57.3+ANG);
	VRY=sin (1.5708-GAMDEG/57.3+ANG);
else
	VRX=cos(-1.5708+GAMDEG/57.3+ANG);
	VRY=sin(-1.5708+GAMDEG/57.3+ANG);
end
X=(A+ALT)*cos(ANG);
Y=(A+ALT)*sin(ANG);
ALT=sqrt(X^2+Y^2)-A;
XFIRST=X;
YFIRST=Y;
X1=VRX;
Y1=VRY;
while ~(ALT <0 && T>10)
	XOLD=X;
	YOLD=Y;
	X1OLD=X1;
	Y1OLD=Y1;
	STEP=1;
	FLAG=0;
	while STEP <=1
		if FLAG==1
			STEP=2;
			X=X+H*XD;
			Y=Y+H*YD;
			X1=X1+H*X1D;
			Y1=Y1+H*Y1D;
			T=T+H;
		end
		if T<TB1 
			WGT=-WP1*T/TB1+WTOT;
			TRST=TRST1;
		elseif T<(TB1+TB2)
			WGT=-WP2*T/TB2+WTOT2+WP2*TB1/TB2;
			TRST=TRST2;
		else
			WGT=WPAY;
			TRST=0.;
		end
		AT=32.2*TRST/WGT;
		VEL=sqrt(X1^2+Y1^2);
		AXT=AT*X1/VEL;
		AYT=AT*Y1/VEL;
		TEMBOT=(X^2+Y^2)^1.5;
		X1D=-GM*X/TEMBOT+AXT;
		Y1D=-GM*Y/TEMBOT+AYT;
		XD=X1;
		YD=Y1;
		FLAG=1;
	end
	FLAG=0;	
	X=(XOLD+X)/2+.5*H*XD;
	Y=(YOLD+Y)/2+.5*H*YD;
	X1=(X1OLD+X1)/2+.5*H*X1D;
	Y1=(Y1OLD+Y1)/2+.5*H*Y1D;
	ALT=sqrt(X^2+Y^2)-A;
 	S=S+H;
	if S>=9.99999
		S=0.;
		R=sqrt(X^2+Y^2);
		RF=sqrt(XFIRST^2+YFIRST^2);
		CBETA=(X*XFIRST+Y*YFIRST)/(R*RF);
		BETA=acos(CBETA);
		DISTNM=A*BETA/6076.;
		ALTNM=(sqrt(X^2+Y^2)-A)/6076.;
		XNM=X/6076.;
		YNM=Y/6076.;
		count=count+1;
		ArrayT(count)=T;
		ArrayDISTNM(count)=DISTNM;
		ArrayALTNM(count)=ALTNM;
	end
end
figure
plot(ArrayDISTNM,ArrayALTNM),grid
xlabel('Downrange (Nmi)')
ylabel('Altitude (Nmi) ')
clc
% output=[ArrayT',ArrayDISTNM',ArrayALTNM'];
% save datfil output /ascii
disp 'simulation finished'


