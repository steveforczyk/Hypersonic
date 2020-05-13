% Convert ECI to NEU 
% Written By: Stephen Forczyk
% Created: March 6,2019
% Revised:----
% Classification: Unclassified

eci=[0,-3748038.177415,3144977.452307,4077992.920490,-229.394055,-273.262014,0.064279,-2.767654,2.322338,2.990806];
ecf=eci2ecf(eci);
EFX=ecf(1,2);
EFY=ecf(1,3);
EFZ=ecf(1,4);
EFVel(1,1)=ecf(1,5);
EFVel(2,1)=ecf(1,6);
EFVel(3,1)=ecf(1,7);
EFAccel(1,1)=ecf(1,8);
EFAccel(2,1)=ecf(1,9);
EFAccel(3,1)=ecf(1,10);
% Now get lla coord to set up the needed rotation matrices

lla=ecf2lla(ecf);

LaunchLat=lla(1,2);
LaunchLon=lla(1,3);
LaunchAlt=0;
spheroid = referenceEllipsoid('GRS 80');
[xEast,yNorth,zUp] = ecef2enu(EFX,EFY,EFZ,LaunchLat,LaunchLon,LaunchAlt,spheroid);
[RENUToECEF,RECEFToENU] = ENUToECEF(LaunchLat,LaunchLon);
[xEast,yNorth,zUp] = ecef2enu(EFX,EFY,EFZ,LaunchLat,LaunchLon,LaunchAlt,spheroid);
% Now get the velocity in ENU
ENUVel=RECEFToENU*EFVel;
% Get the Acceleration in ENU
ENUAccel=RECEFToENU*EFAccel;

ab=1;
% Origin(1,1)=0;
% Origin(1,2)=0;
% Origin(1,3)=0;
% Pos(1,1)=ecf(1,2);
% Pos(1,2)=ecf(1,3);
% Pos(1,3)=ecf(1,4);
% ab=1
% NEU = xyz2neu(Origin,Pos);
% ab=2;

