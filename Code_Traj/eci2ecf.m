function ecf=eci2ecf(eci)
%function ecf=eci2ecf(eci)
%eci should be: [time_of_epoch, X, Y, Z, Vx, Vy, Vz, Ax, Ay, Az]
%code Developed and Tested by Eric Broyles, Photon Research Associates


WER=7.29211585479175000E-05; %rad/sec
theta=WER*(eci(:,1));
cost=cos(theta);
sint=sin(theta);

%Position
ecf(:,1)=eci(:,1);
ecf(:,2)=cost.*eci(:,2)+sint.*eci(:,3);
ecf(:,3)=-sint.*eci(:,2)+cost.*eci(:,3);
ecf(:,4)=eci(:,4);

%Velocity
if size(eci,2)>4
    ecf(:,5)=eci(:,5).*cost+eci(:,6).*sint-WER*(eci(:,2).*sint-eci(:,3).*cost);
    ecf(:,6)=-eci(:,5).*sint+eci(:,6).*cost-WER*(eci(:,2).*cost+eci(:,3).*sint);
    ecf(:,7)=eci(:,7);
end

%Acceleration
if size(eci,2)>8
    ecf(:,8)=cost.*eci(:,8)+sint.*eci(:,9)-2*sint*WER.*eci(:,5)+2*cost*WER.*eci(:,6)-cost*WER^2.*eci(:,2)-sint*WER^2.*eci(:,3);
    ecf(:,9)=-sint.*eci(:,8)+cost.*eci(:,9)-2*cost*WER.*eci(:,5)-2*sint*WER.*eci(:,6)+sint*WER^2.*eci(:,2)-cost*WER^2.*eci(:,3);
    ecf(:,10)=eci(:,10);
end






