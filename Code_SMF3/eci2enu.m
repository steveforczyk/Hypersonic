function [ENUPos,ENUVel,ENUAccel] = eci2enu(eci,LaunchLat,LaunchLon,LaunchAlt)
% This function will convert eci coordinates to enu coordinates
% 
% Written By Stephen Forczyk from multiple sources
% Created: March 9,2019
% Revised: ------
% Classification: Unclassified
ENUPos=zeros(3,1);
% ENUVel=zeros(3,1);
% ENUAccel=zeros(3,1);
% Convert eci to ecf
ecf=eci2ecf(eci);
EFVel(1,1)=ecf(1,5);
EFVel(2,1)=ecf(1,6);
EFVel(3,1)=ecf(1,7);
EFAccel(1,1)=ecf(1,8);
EFAccel(2,1)=ecf(1,9);
EFAccel(3,1)=ecf(1,10);
% Get the ENU Positions
spheroid = referenceEllipsoid('GRS 80');
[xEast,yNorth,zUp] = ecef2enu(ecf(1,2),ecf(1,3),ecf(1,4),LaunchLat,LaunchLon,LaunchAlt,spheroid);
ENUPos(1,1)=xEast;
ENUPos(2,1)=yNorth;
ENUPos(3,1)=zUp;
% Get the rotation Matrices
[RENUToECEF,RECEFToENU] = ENUToECEF(LaunchLat,LaunchLon);
% Now get the velocity in ENU
ENUVel=RECEFToENU*EFVel;
%ENUVel=ENUVel';
% Get the Acceleration in ENU
ENUAccel=RECEFToENU*EFAccel;
%ENUAccel=ENUAccel';
ab=1;
end

