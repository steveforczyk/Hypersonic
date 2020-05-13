% Copyright Ashish Tewari (c) 2006
function xdot=euler313evolve(t,x) 
w=[0.1,-0.5,-1]; 
xdot(1,1)=(sin(x(3))*w(1)+cos(x(3))*w(2))/sin(x(2));
xdot(2,1)=cos(x(3))*w(1)-sin(x(3))*w(2);
xdot(3,1)=w(3)-(sin(x(3))*cos(x(2))*w(1)+cos(x(3))*cos(x(2))*w(2))/sin(x(2));