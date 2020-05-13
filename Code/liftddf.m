% Copyright Ashish Tewari (c) 2006
function K=liftddf(mach,CL,sweep,AR)
M=[0 0.5 1 1.2 1.5 1.8 2];
k0=[0.32 0.3 0.26 0.24 0.27 0.28 0.3];
k100=[1 1 1 1.2222 1.8889 3.1111 3.3333]/(pi*AR);
K0=interp1(M,k0,mach);
K100=interp1(M,k100,mach);
if mach>1/cos(sweep)
    S=0;
elseif CL<=0.1
    S=0.9;
else
    S=0.1/CL-0.1;
end
if S<0
    S=0;
end
K=S*K100+(1-S)*K0;