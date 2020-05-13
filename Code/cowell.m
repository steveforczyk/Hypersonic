% Copyright Ashish Tewari (c) 2006
global mu; mu=1.32712440018e11; 
global mu3; mu3=398600.4; 
global orb;orb=[149597870;0.01667;0;0;0;-100*24*3600];
R0=1e8*[-0.27;1.475;0.001]; 
V0=[-33;-10;1]; 
options=odeset('RelTol',1e-8);
[T,X]=ode45('perturb',[0 100*24*3600],[R0;V0]);
