% This script will read a number of ASC Files
% to extract data to be used in a trajectory flyer program
% Written By: Stephen Forczyk
% Created July 1,2019
% Revised:July 4,2019
% Classification: Unclassified

clear all
clc
global ASCFile ASCFile2 MissileType Object Type;
global ASCFileList ASCData;
global LaunchLat LaunchLon LaunchAlt;
global AimpointLat AimpointLon DestructAlt;
global DestructTime RVApogeeAltitude RVApogeeTime;
global RVReEntryAngle RVReEntryTime;
global RVImpactLat RVImpactLon RVImpactAlt RVImpactTime;
global GDLat GDLon SlantRange;
global ASCTimes GroundRange Altitude AltitudeKm;
global AngleOfAttack FlightPathAng PrecessionCone;
global Thrust CDrag;
global Energy Velocity KE PE EarthMass Gconst;
global RMass MachNum Airspeed;
global TargetLat TargetLon;
global PosECIX PosECIY PosECIZ;
global VelECIX VelECIY VelECIZ;
global AccelECIX AccelECIY AccelECIZ;
global AccelECINGravX AccelECINGravY AccelECINGravZ;
global GravECIx GravECIy GravECIz GravMag;
global Radius AccelECIMag AccelECINoGrav ;
global VECIX VECIY VECIZ;
global ECIX ECIY ECIZ;
global AECIX AECIY AECIZ;
global PosENUX PosENUY PosENUZ;
global PiENU;
global VelENUX VelENUY VelENUZ;
global AccelENUX AccelENUY AccelENUZ;
global SensAccAxial SensAccNormal;
global BodyRateAxial BodyRateY BodyRateZ;
global SMHRMatFile;

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
imachine=2;
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
chart_time=5;
idirector=1;
initialtimestr=datestr(now);
icase=7;
levelstr='Unclassified';
RVImpactLat=0;
RVImpactLon=0;
RVImpactAlt=0;
RVImpactTime=0;
SMHRMatFile=[];
EarthMass=6E24;
Gconst=6.7E-11;
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
ASCData{1,15}='Sensed Axial Accel';
ASCData{1,16}='Sensed Normal Accel';
ASCData{1,17}='BodyRateAxial';
ASCData{1,18}='BodyRateY';
ASCData{1,19}='BodyRateZ';
ASCData{1,20}='ECIX';
ASCData{1,21}='ECIY';
ASCData{1,22}='ECIZ';
ASCData{1,23}='VECIX';
ASCData{1,24}='VECIY';
ASCData{1,25}='VECIZ';
ASCData{1,26}='AECIX';
ASCData{1,27}='AECIY';
ASCData{1,28}='AECIZ';
ASCData{1,29}='ENUX';
ASCData{1,30}='ENUY';
ASCData{1,31}='ENUZ';
ASCData{1,32}='GDLat';
ASCData{1,33}='GDLon';
ASCData{1,34}='Slant Range-km';
ASCData{1,35}='Total Energy';
ASCData{1,36}='Potential Energy';
ASCData{1,37}='Kinetic Energy';

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
elseif(icase==5)
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
elseif(icase==6)
    ascpath='D:\Forczyk\Hypersonic\Allocation5\ASC_Files\';
    excelpath='D:\Forczyk\Hypersonic\Allocation5\Excel_Files\';
    matpath='D:\Forczyk\Hypersonic\Allocation5\MAT_Files\';
    jpegpath='D:\Forczyk\Hypersonic\Allocation5\Jpeg\';
    ASCFileList{1,1}='L063d12p101h-0001_1st_stage.asc';
    ASCFileList{2,1}='L063d12p101h-0001_2nd_stage.asc';
    ASCFileList{3,1}='L063d12p101h-0001_3rd_stage.asc';
    ASCFileList{4,1}='L063d12p101h-0001_rv.asc';
    numfiles=4;
    nheaders=2;
    MissileType='L063d12p101h';
    SMHRMatFile='Allocation5-smhrfile.mat';
elseif(icase==7)
    ascpath='D:\Forczyk\OSCToolVer_2_1\Library\';
    excelpath='D:\Forczyk\OSCToolVer_2_1\Excel_Files\';
    matpath='D:\Forczyk\OSCToolVer_2_1\MAT_Files\';
    jpegpath='D:\Forczyk\OSCToolVer_2_1\Jpeg_Files\';
    ASCFileList{1,1}='L128cD03P35_s501-001.asc';
    numfiles=1;
    nheaders=5;
    MissileType='L128cD03P35';
    SMHRMatFile='Allocation5-smhrfile.mat';
end

% Now load in the desired file(s)
for n=1:numfiles
    eval(['cd ' ascpath(1:length(ascpath)-1)]);
    filename=ASCFileList{n,1};
    [Data]=LoadBMRD58Rev6(filename,nheaders);
    ASCTimes=Data.Time';
    numtimes=length(ASCTimes);
    Altitude=Data.Altitude';
    GDLat=Data.TargetLat';
    GDLon=Data.TargetLong';
    Thrust=Data.Thrust';
%global PosECIX PosECIY PosECIZ;
    AccelECIX=Data.AccelECIx';
    AccelECIY=Data.AccelECIy';
    AccelECIZ=Data.AccelECIz';
    PosECIX=Data.PositionECIx';
    PosECIY=Data.PositionECIy';
    PosECIZ=Data.PositionECIz';
    Radius=zeros(numtimes,1);
    AccelECIMag=zeros(numtimes,1);
    AccelECINoGrav=zeros(numtimes,1);
    AccelECINGravX=zeros(numtimes,1);
    AccelECINGravY=zeros(numtimes,1);
    AccelECINGravZ=zeros(numtimes,1);
    GravECIx=zeros(numtimes,1);
    GravECIy=zeros(numtimes,1);
    GravECIz=zeros(numtimes,1);
    GravMag=zeros(numtimes,1);
    ab=1;
% now calculate the target radius and accel mag vs time,gravity mag
    for m=1:numtimes
        RNow=sqrt((PosECIX(m,1)^2) + (PosECIY(m,1)^2) + (PosECIZ(m,1)^2));
        Radius(m,1)=RNow;
        accNow=sqrt((AccelECIX(m,1)^2) + (AccelECIY(m,1)^2) + (AccelECIZ(m,1)^2));
        AccelECIMag(m,1)=accNow;
        lat=GDLat(m,1);
        lon=GDLon(m,1);
        [gmag,gnorth]=gravity(RNow,lat);
        AccelECINoGrav(m,1)=accNow-gmag;
        GravMag(m,1)=gmag;
        GravECIz(m,1)=-gmag*sind(lat);
        GravECIx(m,1)=-gmag*cosd(lat)*cosd(lon);
        GravECIy(m,1)=-gmag*cosd(lat)*sind(lon);
        AccelECINGravX(m,1)=AccelECIX(m,1)+GravECIx(m,1);
        AccelECINGravY(m,1)=AccelECIY(m,1)+GravECIy(m,1);
        AccelECINGravZ(m,1)=AccelECIZ(m,1)+GravECIz(m,1);
    end
    ab=2;
% Now plot the magnitude of the overall eci accel vs time
    titlestr=strcat(MissileType,'-ECIAccelMagVsTime');
    figstr=strcat(titlestr,'.jpg');
    Plot58ColECIAccelMagVsTime(ASCTimes,AccelECIMag,titlestr,figstr)
% Repeat the plot with the gravity magnitude removed
    titlestr=strcat(MissileType,'-ECIAccelLessGravMagVsTime');
    figstr=strcat(titlestr,'.jpg');
    Plot58ColECIAccelMagVsTime(ASCTimes,AccelECINoGrav,titlestr,figstr)
    titlestr=strcat(MissileType,'-ECIAccelComponentsVsTime');
    figstr=strcat(titlestr,'.jpg');
    Plot58ColECIAccelCompVsTime(ASCTimes,AccelECIX,AccelECIY,AccelECIZ,titlestr,figstr)
    titlestr=strcat(MissileType,'-ECIAccelComponentsLessGravVsTime');
    figstr=strcat(titlestr,'.jpg');
    Plot58ColECIAccelCompVsTime(ASCTimes,AccelECINGravX, AccelECINGravY,...
        AccelECINGravZ,titlestr,figstr)
    titlestr=strcat(MissileType,'-ECIAccelXCompTime');
    figstr=strcat(titlestr,'.jpg');
    Plot58ColECIAccelXCompVsTime(ASCTimes,AccelECIX,GravECIx,titlestr,figstr)
    titlestr=strcat(MissileType,'-ECIAccelYCompTime');
    figstr=strcat(titlestr,'.jpg');
    Plot58ColECIAccelZCompVsTime(ASCTimes,AccelECIY,GravECIy,titlestr,figstr)
    titlestr=strcat(MissileType,'-ECIAccelZCompTime');
    figstr=strcat(titlestr,'.jpg');
    Plot58ColECIAccelZCompVsTime(ASCTimes,AccelECIZ,GravECIz,titlestr,figstr)
end






















































% Import the SMHRHeaderInfo if it exists
a1=isempty(SMHRMatFile);
if(a1==0)
    eval(['cd ' matpath(1:length(matpath)-1)]);
    load(SMHRMatFile);
    dispstr=strcat('Loaded SMHR HeaderData from file-',SMHRMatFile);
    disp(dispstr)
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
    SensAccAxial=zeros(numvals,1);
    SensAccNormal=zeros(numvals,1);
    BodyRateAxial=zeros(numvals,1);
    BodyRateY=zeros(numvals,1);
    BodyRateZ=zeros(numvals,1);
    GDLat=zeros(numvals,1);
    GDLon=zeros(numvals,1);
    SlantRange=zeros(numvals,1);
    Energy=zeros(numvals,1);
    PE=zeros(numvals,1);
    KE=zeros(numvals,1);
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
        SensAccAxial(m,1)=Data.SensAccAxial(1,m);
        SensAccNormal(m,1)=Data.SensAccNormal(1,m);
        BodyRateAxial(m,1)=Data.BodyRateAxial(1,m);
        BodyRateY(m,1)=Data.BodyRateY(1,m);
        BodyRateZ(m,1)=Data.BodyRateZ(1,m);
        ECIX(m,1)=Data.PositionECIx(1,m);
        ECIY(m,1)=Data.PositionECIy(1,m);
        ECIZ(m,1)=Data.PositionECIz(1,m);
        VECIX(m,1)=Data.VelocityECIx(1,m);
        VECIY(m,1)=Data.VelocityECIy(1,m);
        VECIZ(m,1)=Data.VelocityECIz(1,m);
        AECIX(m,1)=Data.AccelECIx(1,m);
        AECIY(m,1)=Data.AccelECIy(1,m);
        AECIZ(m,1)=Data.AccelECIz(1,m);
        GDLat(m,1)=Data.TargetLat(1,m);
        GDLon(m,1)=Data.TargetLong(1,m);
        veli=sqrt((VECIX(m,1)^2) + (VECIY(m,1)^2) + (VECIZ(m,1)^2));
        radi=sqrt((ECIX(m,1)^2) + (ECIY(m,1)^2) + (ECIZ(m,1)^2));
        KE(m,1)=0.5*RMass(m,1)*veli^2;
        PE(m,1)=-Gconst*EarthMass*RMass(m,1)/radi;
        Energy(m,1)=KE(m,1)+PE(m,1);
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
    ASCData{1+n,15}=SensAccAxial;
    ASCData{1+n,16}=SensAccNormal;
    ASCData{1+n,17}=BodyRateAxial;
    ASCData{1+n,18}=BodyRateY;
    ASCData{1+n,19}=BodyRateZ;
    ASCData{1+n,20}=ECIX;
    ASCData{1+n,21}=ECIY;
    ASCData{1+n,22}=ECIZ;
    ASCData{1+n,23}=VECIX;
    ASCData{1+n,24}=VECIY;
    ASCData{1+n,25}=VECIZ;
    ASCData{1+n,26}=AECIX;
    ASCData{1+n,27}=AECIY;
    ASCData{1+n,28}=AECIZ;
    ASCData{1+n,32}=GDLat;
    ASCData{1+n,33}=GDLon;
    ASCData{1+n,35}=Energy;
    ASCData{1+n,36}=PE;
    ASCData{1+n,37}=KE;
% Now calcyulate the ENU Coordinates of the object wrt to the Aimpoint
% Start by completing a 1D vector with all the eci data
    spheroid = referenceEllipsoid('GRS 80');
    for m=1:numvals
        eci(1,1)=ASCTimes(m,1);
        eci(1,2)=ECIX(m,1);
        eci(1,3)=ECIY(m,1);
        eci(1,4)=ECIZ(m,1);
        eci(1,5)=VECIX(m,1);
        eci(1,6)=VECIY(m,1);
        eci(1,7)=VECIZ(m,1);
        eci(1,8)=AECIX(m,1);
        eci(1,9)=AECIY(m,1);
        eci(1,10)=AECIZ(m,1);
 % Now get the corresponding ecef position
        ecf=eci2ecfRev6(eci);
 % Calculate the ENU position using the Matlab Aerospace Toolbox
        [xEast,yNorth,zUp]=geodetic2enu(GDLat(m,1),GDLon(m,1),Altitude(m,1),...
            RVImpactLat,RVImpactLon,0,spheroid);
        
        PosENUX(m,1)=xEast;
        PosENUY(m,1)=yNorth;
        PosENUZ(m,1)=zUp;
        SlantRange(m,1)=sqrt((xEast^2) + (yNorth^2) + (zUp^2))/1000;
    end
    ASCData{1+n,29}=PosENUX;
    ASCData{1+n,30}=PosENUY;
    ASCData{1+n,31}=PosENUZ;
    ASCData{1+n,34}=SlantRange;
end
clear Data
ab=1;
% Now plot the extracted items
for n=1:numfiles
    MissileTypeNow=ASCData{1+n,2};
    ObjTypeNow=ASCData{1+n,3};
    ASCTimes=ASCData{1+n,4};
    AngleOfAttack=ASCData{1+n,7};
    Thrust=ASCData{1+n,10};
    Airspeed=ASCData{1+n,14};
    MachNum=ASCData{1+n,13};
    CDrag=ASCData{1+n,11};
    AltitudeKm=ASCData{1+n,6}/1000;
    SensAccAxial=ASCData{1+n,15};
    SensAccNormal=ASCData{1+n,16};
    BodyRateAxial=ASCData{1+n,17};
    BodyRateY=ASCData{1+n,18};
    BodyRateZ=ASCData{1+n,19};
    Energy=ASCData{1+n,35};
    PE=ASCData{1+n,36};
    KE=ASCData{1+n,37};
    GDLat=ASCData{1+n,32};
    GDLon=ASCData{1+n,33};
    xEast=ASCData{1+n,29}/1000;
    yNorth=ASCData{1+n,30}/1000;
    zUp=ASCData{1+n,31}/1000;
    SlantRange=ASCData{1+n,34};
    titlestr=strcat(MissileTypeNow,'-',ObjTypeNow,'-ThrustVsTime');
    figstr=strcat(titlestr,'.jpg');
    PlotObjectThrustVsTime(ASCTimes,Thrust,levelstr,titlestr,figstr);
    titlestr=strcat(MissileTypeNow,'-',ObjTypeNow,'-MachNumVsAirspeed');
    figstr=strcat(titlestr,'.jpg');
    PlotObjectMachNumVsVel(Airspeed,MachNum,levelstr,titlestr,figstr)
    titlestr=strcat(MissileTypeNow,'-',ObjTypeNow,'-CDragVsMachNum');
    figstr=strcat(titlestr,'.jpg');
    PlotObjectDragCoeffVsMachNum(MachNum,CDrag,levelstr,titlestr,figstr)
    titlestr=strcat(MissileTypeNow,'-',ObjTypeNow,'-AoAVsTime');
    figstr=strcat(titlestr,'.jpg');
    PlotObjectAoAVsTime(ASCTimes,AngleOfAttack,levelstr,titlestr,figstr)
    titlestr=strcat(MissileTypeNow,'-',ObjTypeNow,'-AltVsTime');
    figstr=strcat(titlestr,'.jpg');
    PlotObjectAltVsTime(ASCTimes,AltitudeKm,levelstr,titlestr,figstr) 
    titlestr=strcat(MissileTypeNow,'-',ObjTypeNow,'-AirspeedVsTime');
    figstr=strcat(titlestr,'.jpg');
    PlotObjectAirspeedVsTime(ASCTimes,Airspeed,levelstr,titlestr,figstr)
    titlestr=strcat(MissileTypeNow,'-',ObjTypeNow,'-SensedAccelVsTime');
    figstr=strcat(titlestr,'.jpg');
    PlotObjectSensedAccelVsTime(ASCTimes,SensAccAxial,SensAccNormal,levelstr,titlestr,figstr)
    titlestr=strcat(MissileTypeNow,'-',ObjTypeNow,'-BodyRatesVsTime');
    figstr=strcat(titlestr,'.jpg');
    PlotObjectBodyRatesVsTime(ASCTimes,BodyRateAxial,BodyRateY,BodyRateZ,...
        levelstr,titlestr,figstr)
    titlestr=strcat(MissileTypeNow,'-',ObjTypeNow,'-ENUCoordVsTime');
    figstr=strcat(titlestr,'.jpg');
    PlotObject3DCoord(xEast,yNorth,zUp,levelstr,titlestr,figstr)
    titlestr=strcat(MissileTypeNow,'-',ObjTypeNow,'-SlantRangeVsTime');
    figstr=strcat(titlestr,'.jpg');
    PlotObjectSlantRangeVsTime(ASCTimes,SlantRange,levelstr,titlestr,figstr)
    titlestr=strcat(MissileTypeNow,'-',ObjTypeNow,'-EnergyVsTime');
    figstr=strcat(titlestr,'.jpg');
    PlotObjectEnergyVsTime(ASCTimes,KE,PE,Energy,levelstr,titlestr,figstr)
    titlestr=strcat(MissileTypeNow,'-',ObjTypeNow,'-GroundTraceVsTime');
    figstr=strcat(titlestr,'.jpg');
    if(n==4)
        trt=3;
        CreatePlanisphereRev1(ASCTimes,trt,GDLat,GDLon,titlestr,figstr);
    end
end