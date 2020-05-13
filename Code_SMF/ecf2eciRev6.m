function eci=ecf2eciRev6(ecf)
%eci=ecf2eci(ecf);
%Where ecf = [time x y z x' y' z']
%all times should be in seconds of epoch, and lengths in meters, velocity in m/sec
%x' y' z' are optional
%code Developed and Tested by Eric Broyles, Photon Research Associates
% Renamed by Stephen Forczyk on April 2,2020 to avoid name conflict
WER=7.29211585479175000E-05;
theta=WER*(ecf(:,1));
eci(:,1)=ecf(:,1);
%Position
eci(:,2)=cos(theta).*ecf(:,2)-sin(theta).*ecf(:,3);
eci(:,3)=sin(theta).*ecf(:,2)+cos(theta).*ecf(:,3);
eci(:,4)=ecf(:,4);

%Velocity
if size(ecf,2)>4
    eci(:,5)=ecf(:,5).*cos(theta)-ecf(:,6).*sin(theta)-WER*(ecf(:,2).*sin(theta)+ecf(:,3).*cos(theta));
    eci(:,6)=ecf(:,5).*sin(theta)+ecf(:,6).*cos(theta)+WER*(ecf(:,2).*cos(theta)-ecf(:,3).*sin(theta));
    eci(:,7)=ecf(:,7);
end

%Need Acceleration


