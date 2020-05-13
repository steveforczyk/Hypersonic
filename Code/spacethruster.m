% Copyright Ashish Tewari (c) 2006
function xdot=spacethruster(t,x) 
J1=400; J2=750; J3=850; 
if t>=0 && t<=1 
    u=[1000;0;-1000];
elseif t>5 && t<=5.97
    u=[-1000;-750;750];
else
    u=[0;0;0];
end
xdot(1,1)=x(2)*x(3)*(J2-J3)/J1+u(1)/J1;
xdot(2,1)=x(1)*x(3)*(J3-J1)/J2+u(2)/J2;
xdot(3,1)=x(1)*x(2)*(J1-J2)/J3+u(3)/J3;
xdot(4,1)=(sin(x(6))*x(1)+cos(x(6))*x(2))/sin(x(5));
xdot(5,1)=cos(x(6))*x(1)-sin(x(6))*x(2);
xdot(6,1)=x(3)-(sin(x(6))*cos(x(5))*x(1)+cos(x(6))*cos(x(5))*x(2))/sin(x(5));