% This script will read a number of ASC Files
% to extract data to be used in a trajectory flyer program'
% Written By: Stephen Forczyk
% Created July 1,2019
% Revised:July 4,2019
% Classification: Unclassified

clear all
clc
global ASCFile ASCFile2 MissileType Object Type;
global ASCFileList ASCData;
global LaunchLat LaunchLon LaunchAlt;
global ASCTimes GroundRange Altitude;
global AngleOfAttack FlightPathAng PrecessionCone;
global Thrust CDrag;
global RMass MachNum Airspeed;
global TargetLat TargetLon;
global PosECIX PosECIY PosECIZ;
global VelECIX VelECIY VelECIZ;
global AccelECIX AccelECIY AccelECIZ;
global PosENUX PosENUY PosENUZ;
global VelENUX VelENUY VelENUZ;
global AccelENUX AccelENUY AccelENUZ;

global widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;
global vert2 hor2 machine;
global chart_time;
global Fz1 Fz2;
global idirector mov izoom iwindow;
global matpath;
global jpegpath ;
global smhrpath excelpath ascpath;
global ipowerpoint PowerPointFile scaling stretching padding;
global ichartnum;
% Establish selected run parameters
imachine=3;
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
elseif(imachine==3)
    widd=1296;
    lend=974;
    widd2=1200;
    lend2=840;
end
% Set a specific color order
set(0,'DefaultAxesColorOrder',[1 0 0;
    1 1 0;0 1 0;0 0 1;0.75 0.50 0.25;
    0.5 0.75 0.25; 0.25 1 0.25;0 .50 .75]);
% Set up some defaults for a PowerPoint presentationwhos
scaling='true';
stretching='false';
padding=[75 75 75 75];
igrid=1;
% Set up paramters for graphs that will center them on the screen
[hor1,vert1,Fz1,Fz2,machine]=SetScreenCoordinates(widd,lend);
[hor2,vert2,Fz1,Fz2,machine]=SetScreenCoordinates(widd2,lend2);
chart_time=1;
idirector=1;
initialtimestr=datestr(now);
icase=4;
levelstr='Unclassified';
igrid=1;
ASCFileList=cell(1,1);
ASCData=cell(1,1);
ASCData{1,1}='FileName';
ASCData{1,2}='Missile Type';
ASCData{1,3}='Object Type';
ASCData{1,4}='ASCTimes';
ASCData{1,5}='Ground Range';
ASCData{1,6}='Altitude';
ASCData{1,7}='Angle Of Attack';
ASCData{1,8}='Flight Path Angle';
ASCData{1,9}='PrecessionCone';
ASCData{1,10}='Thrust';
ASCData{1,11}='CDrag';
ASCData{1,12}='RMass';
ASCData{1,13}='MachNum';
ASCData{1,14}='Airspeed';
if(icase==1)
    ascpath='E:\Forczyk\Hypersonic\Excel_Files\L127D07P88\';
    excelpath='E:\Forczyk\Hypersonic\Excel_Files\';
    matpath='E:\Forczyk\Hypersonic\MAT_Files\';
    jpegpath='E:\Forczyk\Hypersonic\Jpeg_Files\';
    ASCFile='L127D07P88_criticalpath.asc';
    nheaders=4;
    LaunchLat=36.00;
    LaunchLon=130.0;
    LaunchAlt=0.0;
    MissileType='L127D07P88';
    ObjectType='CPath';
elseif(icase==2)
    ascpath='E:\Forczyk\Hypersonic\ASC_Files2\';
    excelpath='E:\Forczyk\Hypersonic\Excel_Files\';
    matpath='E:\Forczyk\Hypersonic\MAT_Files\';
    jpegpath='E:\Forczyk\Hypersonic\Jpeg_Files\';
    ASCFile='L167aD12P29.asc';
    nheaders=4;
    LaunchLat=36.00;
    LaunchLon=130.0;
    LaunchAlt=0.0;
    MissileType='L167aD12P29';
    ObjectType='CPath';
elseif(icase==3)
    ascpath='E:\Forczyk\Hypersonic\Hypersonic_ASC_Files\';
    excelpath='E:\Forczyk\Hypersonic\Excel_Files\';
    matpath='E:\Forczyk\Hypersonic\MAT_Files\';
    jpegpath='E:\Forczyk\Hypersonic\Jpeg_Files\';
    ASCFileList{1,1}='i174d04p112v1-0005_1st_stage.asc';
    ASCFileList{2,1}='i174d04p112v1-0005_2nd_stage.asc';
%    ASCFileList{3,1}='i174d04p112v1-0005_rv.asc';
    numfiles=2;
    nheaders=2;
    LaunchLat=36.00;
    LaunchLon=130.0;
    LaunchAlt=0.0;
    MissileType='I174d04P112V1';
elseif(icase==4)
    ascpath='D:\Forczyk\Hypersonic\L128aD07P29\ASC_Files\';
    excelpath='D:\Forczyk\Hypersonic\L128aD07P29\Excel_Files\';
    matpath='D:\Forczyk\Hypersonic\L128aD07P29\MAT_Files\';
    jpegpath='D:\Forczyk\Hypersonic\L128aD07P29\Jpeg_Files\';
    ASCFileList{1,1}='L128aD07P29hr1_1st_stage.asc';
    ASCFileList{2,1}='L128aD07P29hr1_2nd_stage_a.asc';
    ASCFileList{3,1}='L128aD07P29hr1_rv.asc';
    numfiles=3;
    nheaders=2;
    LaunchLat=40.00;
    LaunchLon=140.0;
    LaunchAlt=0.0;
    MissileType='L128ad07p29hr1';
end
% Import the desired files
eval(['cd ' ascpath(1:length(ascpath)-1)]);
for n=1:numfiles
    ASCFile=ASCFileList{n,1};
    [iunder]=strfind(ASCFile,'_');
    numunder=length(iunder);
    [iper]=strfind(ASCFile,'.');
    numper=length(iper);
    is=iunder(1)+1;
    ie=iper(1)-1;
    objstr=ASCFile(is:ie);
    ObjectID=RemoveUnderScores(objstr);
    [Data]=LoadBMRD58Rev3(ASCFile);
    numvals=length(Data.Time);
    dispstr=strcat('58 Col File-',ASCFile,'-had-',num2str(numvals),'-timepoints on it');
    disp(dispstr);
% Now loop through the data one point at a time
    ASCTimes=zeros(numvals,1);
    GroundRange=zeros(numvals,1);
    Altitude=zeros(numvals,1);
    AngleOfAttack=zeros(numvals,1);
    FlightPathAng=zeros(numvals,1);
    PrecessionCone=zeros(numvals,1);
    Thrust=zeros(numvals,1);
    CDrag=zeros(numvals,1);
    RMass=zeros(numvals,1);
    MachNum=zeros(numvals,1);
    Airspeed=zeros(numvals,1);
    TargetLat=zeros(numvals,1);
    TargetLon=zeros(numvals,1);
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
    for m=1:numvals
        ASCTimes(m,1)=Data.Time(1,m);
        GroundRange(m,1)=Data.GroundRange(1,m);
        Altitude(m,1)=Data.Altitude(1,m);
        AngleOfAttack(m,1)=Data.AngleofAttack(1,m);
        FlightPathAng(m,1)=Data.FlightPathAng(1,m);
        PrecessionCone(m,1)=Data.PrecessionCone(1,m);
        Thrust(m,1)=Data.Thrust(1,m);
        CDrag(m,1)=Data.DragCoeff(1,m);
        RMass(m,1)=Data.Mass(1,m);
        MachNum(m,1)=Data.MachNumber(1,m);
        Airspeed(m,1)=Data.Airspeed(1,m);
        TargetLat(m,1)=Data.TargetLat(1,m);
        TargetLon(m,1)=Data.TargetLong(1,m);
        
    end
    ASCData{1+n,1}=ASCFile;
    ASCData{1+n,2}=MissileType;
    ASCData{1+n,3}=ObjectID;
    ASCData{1+n,4}=ASCTimes;
    ASCData{1+n,5}=GroundRange;
    ASCData{1+n,6}=Altitude;
    ASCData{1+n,7}=AngleOfAttack;
    ASCData{1+n,8}=FlightPathAng;
    ASCData{1+n,9}=PrecessionCone;
    ASCData{1+n,10}=Thrust;
    ASCData{1+n,11}=CDrag;
    ASCData{1+n,12}=RMass;
    ASCData{1+n,13}=MachNum;
    ASCData{1+n,14}=Airspeed;
    ab=2;
    clear Data
end
ab=1;
% Now plot the thrust vs time
for n=1:numfiles
    MissileTypeNow=ASCData{1+n,2};
    ObjTypeNow=ASCData{1+n,3};
    ASCTimes=ASCData{1+n,4};
    Thrust=ASCData{1+n,10};
    Airspeed=ASCData{1+n,14};
    MachNum=ASCData{1+n,13};
    CDrag=ASCData{1+n,11};
%     titlestr=strcat(MissileTypeNow,'-',ObjTypeNow,'-ThrustVsTime');
%     figstr=strcat(titlestr,'.jpg');
%     PlotObjectThrustVsTime(ASCTimes,Thrust,levelstr,titlestr,figstr);
end