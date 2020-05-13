% Copyright Ashish Tewari (c) 2006
function E=kepler(e,M);
B=cos(e)-(pi/2-e)*sin(e);
E=M+e*sin(M)/(B+M*sin(e));
fE=E-e*sin(E)-M;
fpE=1-e*cos(E);
dE=-fE/fpE;
E=E+dE;
eps=1e-10;
i=0;
while abs(fE)>eps
fE=E-e*sin(E)-M
fpE=1-e*cos(E);
dE=-fE/fpE;
E=E+dE;
i=i+1
end