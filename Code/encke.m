% Copyright Ashish Tewari (c) 2006
global mu; mu=1.32712440018e11; 
global mu3; mu3=398600.4; 
global orb;orb=[149597870;0.01667;0;0;0;-100*24*3600];
t=0;
i=1;
R0=1e8*[-0.27;1.475;0.001]; 
V0=[-33;-10;1]; 
R=R0;V=V0;
dt=24*3600;
tf=100*dt;
while t<=tf
alpha=zeros(3,1);
beta=zeros(3,1);
[Rb,Vb]=trajE(mu,t,R,V,t+dt); 
rb=norm(Rb);
r=norm(R);
[R3,V3]=orbit(mu,orb,t);
ad=disturb(mu3,R,R3);
beta=mu*dt*(1-(rb/r)^3)/rb^3+ad*dt;
alfa=beta*dt;
R=Rb+alpha;
V=Vb+beta;
Rs(:,i)=R;Vs(:,i)=V;Ts(i,1)=t;
t=t+dt;
i=i+1;
end
end
