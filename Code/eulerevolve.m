% Copyright Ashish Tewari (c) 2006
function xdot=eulerevolve(t,x) 
omega=[0,0.02,-0.01]'; 
xdot(2,1)=omega(2)/(tan(x(3))*sin(x(3))+cos(x(3))); 
xdot(1,1)=(xdot(2,1)*sin(x(3))+omega(1))/(cos(x(3))*cos(x(2))); 
xdot(3,1)=xdot(1,1)*sin(x(2))+omega(3); 