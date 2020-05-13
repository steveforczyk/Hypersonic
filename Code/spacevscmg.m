% Copyright Ashish Tewari (c) 2006
function xdot=spacevscmg(t,x) 
J=diag([4000;7500;8500]); 
Jr=[50 -10 0;-10 100 15;0 15 250]; 
if t>=0 && t<5
Mr=[7;-10;-200];
elseif t>5 && t<10
    Mr=[-7;10;0];
else
    Mr=[0;0;0];
end
wr=[x(1);x(2);x(3)];
w=[x(4);x(5);x(6)];
q=[x(7);x(8);x(9);x(10)];
dwr=inv(Jr)*(Mr-skew(wr)*Jr*wr);
dw=-inv(J+Jr)*(skew(w)*J*w+Jr*(dwr+skew(w)*wr)+skew(w+wr)*Jr*(w+wr));
S=[0 w(3,1) -w(2,1) w(1,1);-w(3,1) 0 w(1,1) w(2,1);w(2,1) -w(1,1) 0 w(3,1);-w(1,1) -w(2,1) -w(3,1) 0];
dq=0.5*S*q;
xdot(1,1)=dwr(1,1);
xdot(2,1)=dwr(2,1);
xdot(3,1)=dwr(3,1);
xdot(4,1)=dw(1,1);
xdot(5,1)=dw(2,1);
xdot(6,1)=dw(3,1);
xdot(7,1)=dq(1,1);
xdot(8,1)=dq(2,1);
xdot(9,1)=dq(3,1);
xdot(10,1)=dq(4,1);