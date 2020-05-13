% Copyright Ashish Tewari (c) 2006
function xdot=gravitygrad(t,x) 
mu = 3.986004e14;
Jzz=106892554.975429;
Jxx=127538483.852694;
Jyy=201272329.171876;
n=2*pi/(60*93);
r=(mu/n^2)^(1/3);
X=-r*sin(x(5));
Y=r*sin(x(4))*cos(x(5));
Z=r*cos(x(4))*cos(x(5));
pdot=-(Jzz-Jyy)*(x(2)*x(3)-3*mu*Y*Z/r^5)/Jxx;
qdot=-(Jxx-Jzz)*(x(1)*x(3)-3*mu*X*Z/r^5)/Jyy;
rdot=-(Jyy-Jxx)*(x(1)*x(2)-3*mu*X*Y/r^5)/Jzz;
phidot=x(1)+(x(2)*sin(x(4))+x(3)*cos(x(4)))/cos(x(5));
thetadot=x(2)*cos(x(4))-x(3)*sin(x(4));
psidot=(x(2)*sin(x(4))+x(3)*cos(x(4)))/cos(x(5));
xdot=[pdot;qdot;rdot;phidot;thetadot;psidot];