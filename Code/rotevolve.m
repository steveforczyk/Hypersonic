% Copyright Ashish Tewari (c) 2006
function c=rotevolve(c0,w,T)
S=[0 -w(3,1) w(2,1);w(3,1) 0 -w(1,1);-w(2,1) w(1,1) 0];
dt=2*pi/(10^6*norm(w))
cdt=eye(3)-S*dt;
t=dt;
c=cdt*c0;
n=1;
while t<=T
    c=cdt*c;
    n=n+1;
    t=t+dt;
end
n