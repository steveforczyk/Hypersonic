% Copyright Ashish Tewari (c) 2006
function C=rotmrp(p)
S=[0 -p(3,1) p(2,1);p(3,1) 0 -p(1,1);-p(2,1) p(1,1) 0];
C=eye(3)+4*(p'*p-1)*S/(1+p'*p)^2+8*S*S/(1+p'*p)^2;