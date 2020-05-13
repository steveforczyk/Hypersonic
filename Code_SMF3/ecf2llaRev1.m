% The following code was provided by Eric Broyles, and velocity added by
% Dan Watts and Stephanie Laster.

function [lla, status]=ecf2lla(ecf)
a=6378137;
e2=6.69437999014e-3;
long=atan2(ecf(:,3),ecf(:,2));

p2s=ecf(:,2).^2+ecf(:,3).^2;
sqrt_p2s=p2s.^.5;
top=ecf(:,4)./sqrt_p2s;
latold=atan2(ecf(:,4),sqrt_p2s);


eps=1000;
jkl=1;
while eps>1e-6% || jkl<10;
    rn=a./(1-e2*(sin(latold)).^2).^.5;
    h=sqrt_p2s./cos(latold)-rn;
    bottom=1-e2*rn./(rn+h);
    lat=atan2(top,bottom);
    eps=abs(latold-lat);
    latold=lat;
    jkl=jkl+1;
end
if jkl>=10
    status = 'B';
else
    status ='G';




    lla(:,1)=ecf(:,1);
    lla(:,2)=lat;
    lla(:,3)=long;
    lla(:,4)=h;

    if size(ecf,2)>4
        xdot=ecf(:,5);
        ydot=ecf(:,6);
        zdot=ecf(:,7);

        vmag = sqrt(xdot.^2+ ydot.^2 + zdot.^2);
        xdot=xdot./vmag;
        ydot=ydot./vmag;
        zdot=zdot./vmag;

        velnorm=[xdot,ydot,zdot];

        U = [cos(lat).*cos(long) cos(lat).*sin(long) sin(lat)];
        E = [-sin(long), cos(long), zeros(size(long,1),1)];
        N=cross(U,E);

        elev = asin(dot(velnorm,U,2));
        heading=atan2(dot(velnorm,E,2),dot(velnorm,N,2));

        lla(:,5)=vmag;
        lla(:,6)=elev;
        lla(:,7)=heading;
    end
end