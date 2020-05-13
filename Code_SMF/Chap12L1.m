count=0;
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
V=0.;
while T <= (TB1+TB2)
 	VOLD=V;
	STEP=1;
	FLAG=0;
	while STEP <=1
		if FLAG==1
			STEP=2;
			V=V+H*A;
			T=T+H;
		end
		if T<TB1
			WGT=-WP1*T/TB1+WTOT;
			TRST=TRST1;
		elseif(T<(TB1+TB2))
			WGT=-WP2*T/TB2+WTOT2+WP2*TB1/TB2;
			TRST=TRST2;
		else
			WGT=WPAY;
			TRST=0.;
		end
		A=32.2*TRST/WGT;
		FLAG=1;
	end
	FLAG=0;
 	V=(VOLD+V)/2+.5*H*A;
 	S=S+H;
	if S>=.99999
		S=0.;
		AG=A/32.2;
		VK=V/1000.;
		count=count+1;
		ArrayT(count)=T;
		ArrayVK(count)=VK;
		ArrayAG(count)=AG;
	end
end
figure
plot(ArrayT,ArrayVK),grid
xlabel('Time (Sec)')
ylabel('Velocity (Ft/Sec) ')
figure
plot(ArrayT,ArrayAG),grid
xlabel('Time (Sec)')
ylabel('Acceleration (G) ')
clc
% output=[ArrayT',ArrayVK',ArrayAG'];
% save datfil.txt output /ascii
disp 'simulation finished'
