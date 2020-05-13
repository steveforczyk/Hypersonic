% Copyright Ashish Tewari (c) 2006
global dtr; dtr = pi/180;
global mu; mu = 3.986004e14;
global S; S = 4;
global c; c=0.5;
global m; m =  350;
global rm; rm = 6378140;
global omega; omega = 2*pi/(23*3600+56*60+4.0905);
global Gamma; Gamma=1.41; 
global f8; f8 = fopen('data8.mat', 'a'); 
long = -10*dtr;            
lat = -79.8489182889*dtr; 
rad= 6579.89967e3;  
vel= 7589.30433867; 
fpa= 0.54681217*dtr;
chi= 99.955734*dtr; 
options = odeset('RelTol', 1e-8);    
orbinit = [long; lat; rad; vel; fpa; chi]; 
%orbinit = [-0.5758;1.1542; 7.1916e+06;6.3019e+03;0.0017; 4.2643]; 
[t, o] = ode45('reentry',[0, 1750],orbinit,options);

fclose('all');
