function lla=ecf2lla(ecf)
%lla=ecf2lla(ecf)
%ecf =[seconds_of_epoch x y z]
%lla = [ seconds_of_epoch lat(deg) long(deg) alt(m)]
%code Developed and Tested by Eric Broyles, Photon Research Associates

a=6378137;
e2=6.69437999014e-3;
long=atan2(ecf(:,3),ecf(:,2));
p2s=ecf(:,2).^2+ecf(:,3).^2;
sqrt_p2s=p2s.^.5;
top=ecf(:,4)./sqrt_p2s;
latold=atan2(ecf(:,4),sqrt_p2s);


eps=1000; 
while eps>1e-6
    rn=a./(1-e2*(sin(latold)).^2).^.5;
    h=sqrt_p2s./cos(latold)-rn;
    bottom=1-e2*rn./(rn+h);
    lat=atan2(top,bottom);
    eps=abs(latold-lat);
    latold=lat;
end   

lla(:,1)=ecf(:,1);
lla(:,4)=h;
lla(:,2)=rad2deg(lat);
lla(:,3)=rad2deg(long);
	