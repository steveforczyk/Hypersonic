% Copyright Ashish Tewari (c) 2006
function xdot=spacesymm(t,x)
J1=1500; J3=500; 
n=1; 
thd2=acos(J3/(J1-J3));
xdot(1,1)=x(2)*n*(J1-J3)/J1;%Euler's eqn.(1)
xdot(2,1)=x(1)*n*(J3-J1)/J1;%Euler's eqn.(2)
xdot(3,1)=(sin(x(4))*x(1)+cos(x(4))*x(2))/sin(thd2); %precession rate 
xdot(4,1)=n*(1-J3/J1); %inertial spin rate