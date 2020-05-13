% Copyright Ashish Tewari (c) 2006
function Xdot=res3body(t,X)
m=0.00095369; 
x=X(1); 
y=X(2); 
r1=sqrt((x-m)^2+y^2); 
r2=sqrt((x+1-m)^2+y^2); 
Xdot(1,1)=X(3); 
Xdot(2,1)=X(4);
Xdot(3,1)=x+2*Xdot(2,1)-(1-m)*(x-m)/r1^3-m*(x+1-m)/r2^3;
Xdot(4,1)=y-2*Xdot(1,1)-(1-m)*y/r1^3-m*y/r2^3;