% This script will test process 58 col files
% Purpose is to read a single 58 col file to test
% routines to create asc files from smhr file
%
% Written By: Stephen Forczyk
% Created: March 9,2019
% Revised:   ------
% Classification: Unclassified
clear all
clc
global ASCFile ASCFile2;
global LaunchLat LaunchLon LaunchAlt;
global ASCTimes GroundRange Altitude;
global AngleOfAttack FlightPathAng PrecessionCone;
global PosECIX PosECIY PosECIZ;
global VelECIX VelECIY VelECIZ;
global AccelECIX AccelECIY AccelECIZ;
global PosENUX PosENUY PosENUZ;
global VelENUX VelENUY VelENUZ;
global AccelENUX AccelENUY AccelENUZ;
global CalcPosENUx CalcPosENUy CalcPosENUz;
global CalcVelENUx CalcVelENUy CalcVelENUz;
global CalcAccelENUx CalcAccelENUy CalcAccelENUz;
global DiffENUx DiffENUy DiffENUz;
global DiffENUVelx DiffENUVely DiffENUVelz;
global DiffENUAccelx DiffENUAccely DiffENUAccelz;

global initialtimestr igrid ilog imovie;
global legendstr1 legendstr2 legendstr3;
global fid fid2 fid3;
global vert1 hor1 widd lend;
global vert2 hor2 widd2 lend2 machine;
global chart_time;
global Fz1 Fz2;
global idirector mov izoom iwindow;
global matpath excelpath ascpath jpegpath;
global ipowerpoint scaling stretching padding;
global ichartnum;

% Establish selected run parameters
imachine=1;
if(imachine==1)
    widd=720;
    lend=580;
    widd2=1000;
    lend2=700;
elseif(imachine==2)
    widd=1080;
    lend=812;
    widd2=1000;
    lend2=700;
end
% Set a specific color order
set(0,'DefaultAxesColorOrder',[1 0 0;
    1 1 0;0 1 0;0 0 1;0.75 0.50 0.25;
    0.5 0.75 0.25; 0.25 1 0.25;0 .50 .75]);
% Set up some defaults for a PowerPoint presentation
scaling='true';
stretching='false';
padding=[75 75 75 75];
% Set up paramters for graphs that will center them on the screen
[hor1,vert1,Fz1,Fz2,machine]=SetScreenCoordinates(widd,lend);
[hor2,vert2,Fz1,Fz2,machine]=SetScreenCoordinates(widd2,lend2);
chart_time=1;
idirector=1;
initialtimestr=datestr(now);
icase=1;
if(icase==1)
    ascpath='H:\MDSET\Trajectories\ASC_Files\';
    excelpath='H:\MDSET\Trajectories\Excel_Files\';
    matpath='H:\MDSET\Trajectories\MAT_Files\';
    jpegpath='H:\MDSET\Trajectories\Jpeg_Files\';
    ASCFile='TC-A01-I315bD03P27-4.asc';
    nheaders=5;
    LaunchLat=40.448400;
    LaunchLon=128.929900;
    LaunchAlt=0.0;
end
% Import the desired file
eval(['cd ' ascpath(1:length(ascpath)-1)]);
[Data]=LoadBMRD58Rev3(ASCFile,nheaders);
numvals=length(Data.Time);
dispstr=strcat('58 col file-',ASCFile,'-had-',num2str(numvals),'-timepoints on it');
disp(dispstr);
% Now loop through the data one point at a time
ASCTimes=zeros(numvals,1);
GroundRange=zeros(numvals,1);
Altitude=zeros(numvals,1);
AngleOfAttack=zeros(numvals,1);
FlightPathAng=zeros(numvals,1);
PrecessionCone=zeros(numvals,1);
PosECIX=zeros(numvals,1);
PosECIY=zeros(numvals,1);
PosECIZ=zeros(numvals,1);
VelECIX=zeros(numvals,1);
VelECIY=zeros(numvals,1);
VelECIZ=zeros(numvals,1);
AccelECIX=zeros(numvals,1);
AccelECIY=zeros(numvals,1);
AccelECIZ=zeros(numvals,1);
PosENUX=zeros(numvals,1);
PosENUY=zeros(numvals,1);
PosENUZ=zeros(numvals,1);
VelENUX=zeros(numvals,1);
VelENUY=zeros(numvals,1);
VelENUZ=zeros(numvals,1);
AccelENUX=zeros(numvals,1);
AccelENUY=zeros(numvals,1);
AccelENUZ=zeros(numvals,1);
CalcPosENUx=zeros(numvals,1);
CalcPosENUy=zeros(numvals,1);
CalcPosENUz=zeros(numvals,1);
CalcVelENUx=zeros(numvals,1);
CalcVelENUy=zeros(numvals,1);
CalcVelENUz=zeros(numvals,1);
CalcAccelENUx=zeros(numvals,1);
CalcAccelENUy=zeros(numvals,1);
CalcAccelENUz=zeros(numvals,1);
DiffENUx=zeros(numvals,1);
DiffENUy=zeros(numvals,1);
DiffENUz=zeros(numvals,1);
DiffENUVelx=zeros(numvals,1);
DiffENUVely=zeros(numvals,1);
DiffENUVelz=zeros(numvals,1);
DiffENUAccelx=zeros(numvals,1);
DiffENUAccely=zeros(numvals,1);
DiffENUAccelz=zeros(numvals,1);
for n=1:numvals
    ASCTimes(n,1)=Data.Time(n,1);
    GroundRange(n,1)=Data.GroundRange(n,1);
    Altitude(n,1)=Data.Altitude(n,1);
    AngleOfAttack(n,1)=Data.AngleofAttack(n,1);
    FlightPathAng(n,1)=Data.FlightPathAng(n,1);
    PrecessionCone(n,1)=Data.PrecessionCone(n,1);
    PosECIX(n,1)=Data.PositionECIx(n,1);
    PosECIY(n,1)=Data.PositionECIy(n,1);
    PosECIZ(n,1)=Data.PositionECIz(n,1);
    VelECIX(n,1)=Data.VelocityECIx(n,1);
    VelECIY(n,1)=Data.VelocityECIy(n,1);
    VelECIZ(n,1)=Data.VelocityECIz(n,1);
    AccelECIX(n,1)=Data.AccelECIx(n,1);
    AccelECIY(n,1)=Data.AccelECIy(n,1);
    AccelECIZ(n,1)=Data.AccelECIz(n,1);
    PosENUX(n,1)=Data.PositionENUx(n,1);
    PosENUY(n,1)=Data.PositionENUy(n,1);
    PosENUZ(n,1)=Data.PositionENUz(n,1);
    VelENUX(n,1)=Data.VelocityENUx(n,1);
    VelENUY(n,1)=Data.VelocityENUy(n,1);
    VelENUZ(n,1)=Data.VelocityENUz(n,1);
    AccelENUX(n,1)=Data.AccelENUx(n,1);
    AccelENUY(n,1)=Data.AccelENUy(n,1);
    AccelENUZ(n,1)=Data.AccelENUz(n,1);
% Now calculate the ENU coordinates independently
% Start by completing a 1D vector with all the eci data
    eci(1,1)=ASCTimes(n,1);
    eci(1,2)=PosECIX(n,1);
    eci(1,3)=PosECIY(n,1);
    eci(1,4)=PosECIZ(n,1);
    eci(1,5)=VelECIX(n,1);
    eci(1,6)=VelECIY(n,1);
    eci(1,7)=VelECIZ(n,1);
    eci(1,8)=AccelECIX(n,1);
    eci(1,9)=AccelECIY(n,1);
    eci(1,10)=AccelECIZ(n,1);
% Now get the corresponding ecef position
    ecf=eci2ecf(eci);
% Calculate Just the ENU Position using the Matlab Aerospace toolbox
% function
    spheroid = referenceEllipsoid('GRS 80');
    [xEast,yNorth,zUp] = ecef2enu(ecf(1,2),ecf(1,3),ecf(1,4),LaunchLat,LaunchLon,LaunchAlt,spheroid);
    CalcPosENUx(n,1)=xEast;
    CalcPosENUy(n,1)=yNorth;
    CalcPosENUz(n,1)=zUp;
    DiffENUx(n,1)=xEast-PosENUX(n,1);
    DiffENUy(n,1)=yNorth-PosENUY(n,1);
    DiffENUz(n,1)=zUp-PosENUZ(n,1);
% Calculate the needed rotation matrices
    [RENUToECEF,RECEFToENU] = ENUToECEF(LaunchLat,LaunchLon);
    EFVel(1,1)=ecf(1,5);
    EFVel(2,1)=ecf(1,6);
    EFVel(3,1)=ecf(1,7);
    EFAccel(1,1)=ecf(1,8);
    EFAccel(2,1)=ecf(1,9);
    EFAccel(3,1)=ecf(1,10);
% Calculate the Velocity Components in ENU
    ENUVel=RECEFToENU*EFVel;
    CalcVelENUx(n,1)=ENUVel(1,1);
    CalcVelENUy(n,1)=ENUVel(2,1);
    CalcVelENUz(n,1)=ENUVel(3,1);
    DiffENUVelx(n,1)=ENUVel(1,1)-VelENUX(n,1);
    DiffENUVely(n,1)=ENUVel(2,1)-VelENUY(n,1);
    DiffENUVelz(n,1)=ENUVel(3,1)-VelENUZ(n,1);
    ab=2;
% Calculate hte Accel Components in ENU  
    ENUAccel=RECEFToENU*EFAccel;
    CalcAccelENUx(n,1)=ENUAccel(1,1);
    CalcAccelENUy(n,1)=ENUAccel(2,1);
    CalcAccelENUz(n,1)=ENUAccel(3,1);
    DiffENUAccelx(n,1)=ENUAccel(1,1)-AccelENUX(n,1);
    DiffENUAccely(n,1)=ENUAccel(2,1)-AccelENUY(n,1);
    DiffENUAccelz(n,1)=ENUAccel(3,1)-AccelENUZ(n,1);
end
ab=1;
% Now plot the ENU positions differences over time
[iper]=strfind(ASCFile,'.');
numper=length(iper);
is=1;
ie=iper(numper)-1;
filestub=ASCFile(is:ie);
titlestr=strcat(filestub,'-ENU-Position-Differences');
figstr=strcat(titlestr,'.jpg');
PlotENUPosDifferences(titlestr,figstr)
% Now plot the velocity differences
titlestr=strcat(filestub,'-ENU-Velocity-Differences');
figstr=strcat(titlestr,'.jpg');
PlotENUVelDifferences(titlestr,figstr)
% Now plot the accel differences
titlestr=strcat(filestub,'-ENU-Acceleration-Differences');
figstr=strcat(titlestr,'.jpg');
PlotENUAccelDifferences(titlestr,figstr)
ab=4;