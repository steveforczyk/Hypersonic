% Copyright Ashish Tewari (c) 2006
function p=Nstage(vf,beta,epsilon,alpha)
itrial=0;
N=size(beta,1);
p=0.1;
f=vf;
tol=1e-9;
    for k=1:N
        f=f+beta(k)*log(epsilon(k)+alpha(k)*(1-epsilon(k))*p);
    end
    while abs(f)>tol
    f=vf;
    fp=0;
    itrial=itrial+1;
        for k=1:N
            f=f+beta(k)*log(epsilon(k)+alpha(k)*(1-epsilon(k))*p);
            fp=fp+alpha(k)*beta(k)/(epsilon(k)+alpha(k)*(1-epsilon(k))*p);
        end
    d=-f/fp;
    p=p+d;
    dispstr=strcat('itrial=',num2str(itrial),'-payload ratio=',num2str(p));
    disp(dispstr)
end