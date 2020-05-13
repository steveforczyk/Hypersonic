% Copyright Ashish Tewari (c) 2006
function q=quatevolve(q0,w,T)
S=[0 w(3,1) -w(2,1) w(1,1);-w(3,1) 0 w(1,1) w(2,1);w(2,1) -w(1,1) 0 w(3,1);-w(1,1) -w(2,1) -w(3,1) 0];
q=expm(0.5*S*T)*q0;