% Copyright Ashish Tewari (c) 2006
J1=1500; J3=500; 
thd2=acos(J3/(J1-J3))
T=0.01;
n=1; 
Ts=pi/abs(n*(1-J3/J1))
x=[];
x(1,1)=0;
x(2,1)=J3*n*tan(thd2)/J1;
x(3,1)=0;x(4,1)=0;
[t1,x1]=ode45(@spacesymm,[0 Ts],x);
N=size(t1,1);
x(1,1)=0;
x(2,1)=0;
x(3,1)=x1(N,3);x(4,1)=x1(N,4);
[t2,x2]=ode45(@spacesymm,[Ts+T Ts+T+1.5],x);
t=[t1;t2];x=[x1;x2];
dtr=pi/180;
plot(t,x(:,1:2)/dtr,t,sqrt(x(:,1).*x(:,1)+x(:,2).*x(:,2))/dtr),...
    xlabel('Time (s)'),ylabel('Precession angular velocity (deg./s)')
figure
plot(t,x(:,3)/dtr,t,x(:,4)/dtr),xlabel('Time (s)'),...
    ylabel('Precession angle, \psi, inertial spin angle, \phi (deg.)')