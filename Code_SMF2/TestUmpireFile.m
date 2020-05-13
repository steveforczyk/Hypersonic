% This script will test process a 58 col file created
% by UMPIRE to calculate the target to sensor aspect angle
%
% Written By: Stephen Forczyk
% Created: April 30,2019
% Revised:   ------
% Classification: Unclassified
clear all
clc
global ASCFile ASCFile2;
global LaunchLat LaunchLon LaunchAlt;
global TargetLat TargetLon TargetAlt;
global ASCTimes GroundRange Altitude;
global AngleOfAttack FlightPathAng PrecessionCone;
global Thrust CGAxial;
global PosECIX PosECIY PosECIZ;
global VelECIX VelECIY VelECIZ;
global PosENUX PosENUY PosENUZ;
global VelENUX VelENUY VelENUZ;
global AccelECIX AccelECIY AccelECIZ
global AccelENUX AccelENUY AccelENUZ;
global SensAccAxial SensAccNormal;
global RollAngleECI PitchAngleECI YawAngleECI;
global RollAngleENU PitchAngleENU YawAngleENU;
global BodyRateAxial BodyRateY BodyRateZ;
global BallisticCoeff Mass;
global CPPitchPlane CPYawPlane;
global Airspeed Ixx Iyy Izz;
global TimeOfLiftoff MachNumber;
global SensedAccelY SensedAccelZ;
global DynamicPress PitchAoA YawAoA;
global TimeLastState TgtTrajLat TgtTrajLong;
global DragCoeff CMalphaSlope TALO;
global SensorFile;
global numtargettimes numsentimes;
global SensorTimes SensorRangeKm SensorAzimuth SensorElevation;
global SensorAspect SensorPosECIX SensorPosECIY SensorPosECIZ;
global SensorVelECIX SensorVelECIY SensorVelECIZ;
global SensorRoll SensorPitch SensorYaw SensorFace;
global SenFixedLat SenFixedLon SenFixedAlt;
global AspectError;

global CalcPosENUx CalcPosENUy CalcPosENUz;
global CalcVelENUx CalcVelENUy CalcVelENUz;
global CalcAccelENUx CalcAccelENUy CalcAccelENUz;
global DiffENUx DiffENUy DiffENUz;
global DiffENUVelx DiffENUVely DiffENUVelz;
global DiffENUAccelx DiffENUAccely DiffENUAccelz;
global CalcTimes CalcSlantRangeKM CalcSenAspect TrueTgtAspect;
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
classification='Unclassified';
icase=1;
if(icase==1)
    ascpath='D:\Trajectories\Umpire\RussiaToPA_L128aD03P27H\';
    excelpath='D:\Trajectories\Umpire\Excel_Files\';
    matpath='D:\Trajectories\Umpire\MAT_Files\';
    jpegpath='D:\Trajectories\Umpire\Jpeg\';
    ASCFile='RussiaToPA_L128aD03P27H_RV.asc';
    SensorFile='RussiaToPA_L128aD03P27H_FishEye_6_RV.Sensor';
    nheaders=5;
    LaunchLat=59.9170;
    LaunchLon=30.4170;
    LaunchAlt=2.0;
    TargetLat=40.2670;
    TargetLon=-76.8832;
    TargetAlt=-5;
    headerlinesIn=3;
% Norway Fixed Sensor
    SenFixedLat=58.778100;
    SenFixedLon=10.826200;
    SenFixedAlt=0;
    AspectPlot='NorwayAspectVsTime';
% Iceland Fixed Sensor
%     SenFixedLat=64.241;
%     SenFixedLon=-20.118;
%     SenFixedAlt=0;
elseif(icase==2)
    ascpath='D:\Trajectories\Umpire\RussiaToPA_L128aD03P27H\';
    excelpath='D:\Trajectories\Umpire\Excel_Files\';
    matpath='D:\Trajectories\Umpire\MAT_Files\';
    jpegpath='D:\Trajectories\Umpire\Jpeg\';
    ASCFile='RussiaToPA_L128aD03P27H_RV.asc';
    SensorFile='RussiaToPA_L128aD03P27H_FishEye2_9_RV.Sensor';
    nheaders=5;
    LaunchLat=59.9170;
    LaunchLon=30.4170;
    LaunchAlt=2.0;
    TargetLat=40.2670;
    TargetLon=-76.8832;
    TargetAlt=-5;
    headerlinesIn=3;
    AspectPlot='IcelandAspectVsTime';
% Iceland Fixed Sensor
    SenFixedLat=64.241;
    SenFixedLon=-20.118;
    SenFixedAlt=0;
end
tic;
% Import the desired file
eval(['cd ' ascpath(1:length(ascpath)-1)]);
[Data]=LoadUmpire58ColFile(ASCFile,nheaders);
numvals=length(Data.Time);
% Now apportion the data out to the correct arrays
ASCTimes=Data.Time;
numtargettimes=numvals;
GroundRange=Data.GroundRange;
Altitude=Data.Altitude;
AngleOfAttack=Data.AngleofAttack;
FlightPathAng=Data.FlightPathAng;
PrecessionCone=Data.PrecessionCone;
Thrust=Data.Thrust;
CGAxial=Data.CGAxial;
PosECIX=Data.PositionECIx;
PosECIY=Data.PositionECIy;
PosECIZ=Data.PositionECIz;
PosENUX=Data.PositionENUx;
PosENUY=Data.PositionENUy;
PosENUZ=Data.PositionENUz;
VelECIX=Data.VelocityECIx;
VelECIY=Data.VelocityECIy;
VelECIZ=Data.VelocityECIz;
VelENUX=Data.VelocityENUx;
VelENUY=Data.VelocityENUy;
VelENUZ=Data.VelocityENUz;
AccelECIX=Data.AccelECIx;
AccelECIY=Data.AccelECIy;
AccelECIZ=Data.AccelECIz;
AccelENUX=Data.AccelENUx;
AccelENUY=Data.AccelENUy;
AccelENUZ=Data.AccelENUz;
SensAccAxial=Data.SensAccAxial;
SensAccNormal=Data.SensAccNormal;
RollAngleECI=Data.RollAngleECI;
PitchAngleECI=Data.PitchAngleECI;
YawAngleECI=Data.YawAngleECI;
RollAngleENU=Data.RollAngleENU;
PitchAngleENU=Data.PitchAngleENU;
YawAngleENU=Data.YawAngleENU;
BodyRateAxial=Data.BodyRateAxial;
BodyRateY=Data.BodyRateY;
BodyRateZ=Data.BodyRateZ;
BallisticCoeff=Data.BallisticCoeff;
Mass=Data.Mass;
CPPitchPlane=Data.CPPitchPlane;
CPYawPlane=Data.CPYawPlane;
Airspeed=Data.Airspeed;
Ixx=Data.Ixx;
Iyy=Data.Iyy;
Izz=Data.Izz;
TimeOfLiftoff=Data.TimeOfLiftoff;
MachNumber=Data.MachNumber;
SensedAccelY=Data.SensedAccelY;
SensedAccelZ=Data.SensedAccelZ;
DynamicPress=Data.DynamicPress;
PitchAoA=Data.PitchAoA;
YawAoA=Data.YawAoA;
TimeLastState=Data.TimeLastState;
TgtTrajLat=Data.TargetLat;
TgtTrajLong=Data.TargetLong;
DragCoeff=Data.DragCoeff;
CMalphaSlope=Data.CMalphaSlope;
TALO=Data.TALO;
dispstr=strcat('58 col file-',ASCFile,'-had-',num2str(numvals),'-timepoints on it');
disp(dispstr);
% Now import the sensor file
SensorData = importdata(SensorFile,',',headerlinesIn);
SensorTimes=SensorData.data(:,1);
SensorRangeKm=SensorData.data(:,2);
SensorAzimuth=SensorData.data(:,3);
SensorElevation=SensorData.data(:,4);
SensorAspect=SensorData.data(:,5);
SensorPosECIX=SensorData.data(:,6);
SensorPosECIY=SensorData.data(:,7);
SensorPosECIZ=SensorData.data(:,8);
SensorVelECIX=SensorData.data(:,9);
SensorVelECIY=SensorData.data(:,10);
SensorVelECIZ=SensorData.data(:,11);
SensorRoll=SensorData.data(:,12);
SensorPitch=SensorData.data(:,13);
SensorYaw=SensorData.data(:,14);
SensorFace=SensorData.data(:,15);
numsentimes=length(SensorTimes);
if(numsentimes>0)
    startSenCoverage=SensorTimes(1,1);
    endSenCoverage=SensorTimes(numsentimes,1);

% Get the corresponding indices in the target list
    itgtstart=0;
    itgtend=0;
    for n=1:numtargettimes
        nowTgtTime=ASCTimes(n,1);
        diff1=abs(startSenCoverage-nowTgtTime);
        diff2=abs(endSenCoverage-nowTgtTime);
        if(diff1<.01)
            itgtstart=n;
        end
        if(diff2<.01)
            itgtend=n;
        end
    end
% Now loop through the data
    imatch=itgtend-itgtstart+1;
    iloop=0;
    CalcTimes=zeros(imatch,1);
    CalcSlantRangeKM=zeros(imatch,1);
    CalcSenAspect=zeros(imatch,1);
    AspectError=zeros(imatch,1);
    TrueTgtAspect=zeros(imatch,1);
    for n=itgtstart:itgtend
        iloop=iloop+1;
        CalcTimes(iloop,1)=ASCTimes(n,1);
% Get the target position
        ECITgtX=PosECIX(n,1);
        ECITgtY=PosECIY(n,1);
        ECITgtZ=PosECIZ(n,1);
        lla_data(1,1)=ASCTimes(n,1);
        lla_data(1,2)=SenFixedLat*pi/180;
        lla_data(1,3)=SenFixedLon*pi/180;
        lla_data(1,4)=SenFixedAlt;
        eci_data=lla2eci(lla_data);
        ECISenX=eci_data(1,2);
        ECISenY=eci_data(1,3);
        ECISenZ=eci_data(1,4);
        LOSx=-(ECITgtX-ECISenX);
        LOSy=-(ECITgtY-ECISenY);
        LOSz=-(ECITgtZ-ECISenZ);
        LOSSize=sqrt((LOSx^2) + (LOSy^2) + (LOSz^2)); 
        LOS=[LOSx  LOSy LOSz]/LOSSize;
        sr=sqrt((LOSx^2) + (LOSy^2) + (LOSz^2));
        srkm=sr/1000;
        CalcSlantRangeKM(iloop,1)=srkm;
% Get the current yaw pitch and roll angles
        yaw=YawAngleECI(n,1);
        pitch=PitchAngleECI(n,1);
        roll=RollAngleECI(n,1);
        trueasp=SensorAspect(iloop,1);
 %       TrueTgtAspect(iloop,1)=trueasp;
        [QXx] = ypr_to_dcm(yaw,pitch,roll);
        QxX=QXx';
        Body1=[1,0,0]';
        Body2=[0,1,0]';
        Body3=[0,0,1]';
        ECI1X=QxX*Body1;
        prodx=dot(ECI1X,LOS);
        ang=acosd(prodx);
        CalcSenAspect(iloop,1)=ang;
        AspectError(iloop,1)=ang-trueasp;
        ab=1;
    end
    titlestr=AspectPlot;
    figstr=strcat(titlestr,'.jpg');
    PlotTargetAspectVsTime(CalcTimes,CalcTimes,SensorAspect,CalcSenAspect,...
    classification,titlestr,figstr)
end
elapsed_time=toc;
dispstr=strcat('Run took-',num2str(elapsed_time),'-seconds');
disp(dispstr)