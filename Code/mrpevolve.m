% Copyright Ashish Tewari (c) 2006
function pdot=mrpevolve(t,p) 
w=[0.1;-0.5;-1];  
S=[0 -p(3,1) p(2,1);p(3,1) 0 -p(1,1);-p(2,1) p(1,1) 0];
G=0.5*(eye(3)+S+p*p'-0.5*(1+p'*p)*eye(3));
pdot=G*w;