% Copyright Ashish Tewari (c) 2006
function H=keplerhyp(e,M);
H=M;
fH=e*sinh(H)-H-M;
fpH=e*cosh(H)-1;
dH=-fH/fpH;
H=H+dH;
eps=1e-10;
i=0;
while abs(fH)>eps
i=i+1  
fH=e*sinh(H)-H-M
fpH=e*cosh(H)-1;
dH=-fH/fpH;
H=H+dH
end