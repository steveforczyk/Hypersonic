function [RENUToECEF,RECEFToENU] = ENUToECEF(Lat,Lon)
% This will create the rotation Matrix from ENU to ECEF
% and as a bonus ECEF to ENU
% Written By: Stephen Forczyk
% Created: March 7,2019
% Revised:----------
% Classification: Unclassified
% Source https://gssc.esa.int/navipedia/index.php/Transformations_between_ECEF_and_ENU_coordinates

R1=zeros(3,3);
R2=zeros(3,3);
% Get the ENU to ECEF rotation matrix
R1(1,1)=-sind(Lon);
R1(1,2)=-cosd(Lon)*sind(Lat);
R1(1,3)=cosd(Lon)*cosd(Lat);
R1(2,1)=cosd(Lon);
R1(2,2)=-sind(Lon)*sind(Lat);
R1(2,3)=sind(Lon)*cosd(Lat);
R1(3,1)=0;
R1(3,2)=cosd(Lat);
R1(3,3)=sind(Lat);
% To Go from ECEF to ENU is just the transpose
R2=R1';
RENUToECEF=R1;
RECEFToENU=R2;
end

