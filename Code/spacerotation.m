% Copyright Ashish Tewari (c) 2006
function xdot=spacerotation(t,x) 
J1=4000; J2=7500; J3=8500; 
xdot(1,1)=x(2)*x(3)*(J2-J3)/J1;
xdot(2,1)=x(1)*x(3)*(J3-J1)/J2;
xdot(3,1)=x(1)*x(2)*(J1-J2)/J3;
xdot(4,1)=(sin(x(6))*x(1)+cos(x(6))*x(2))/sin(x(5));
xdot(5,1)=cos(x(6))*x(1)-sin(x(6))*x(2);
xdot(6,1)=x(3)-(sin(x(6))*cos(x(5))*x(1)+cos(x(6))*cos(x(5))*x(2))/sin(x(5));