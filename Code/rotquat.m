% Copyright Ashish Tewari (c) 2006
function C=rotquat(q)
S=[0 -q(3,1) q(2,1);q(3,1) 0 -q(1,1);-q(2,1) q(1,1) 0];
C=(q(4,1)^2-q(1:3,1)'*q(1:3,1))*eye(3)+2*q(1:3,1)*q(1:3,1)'-2*q(4,1)*S;