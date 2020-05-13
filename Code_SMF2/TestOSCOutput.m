% This script will test process a OSC output to see if
% we correctly calculate the targets aspect using a combination
% of OSC output files
%
% Written By: Stephen Forczyk
% Created: May 4,2019
% Revised:   ------
% Classification: Unclassified
clear all
clc
global BSTTime BSTECIx BSTECIy BSTECIz;
global BSTECIVx BSTECIVy BSTECIVz;
global BSTEulerPhi BSTEulerTheta BSTEulerPsi;
global TimeECITarg ECIP ECIV;
global TimeECISen ECIPS ECIVS;
global XBODI YBODI ZBODI;
global PITCHI YAWI ROLLI;
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
global SensorFile ScenarioID;
global numtargettimes numsentimes;
global SensorTimes SensorRangeKm SensorAzimuth SensorElevation;
global SensorAspect SensorPosECIX SensorPosECIY SensorPosECIZ;
global SensorVelECIX SensorVelECIY SensorVelECIZ;
global SensorRoll SensorPitch SensorYaw SensorFace;
global SenFixedLat SenFixedLon SenFixedAlt;
global AspectError;
global SumarySigsFile;
global SummarySigsTime SummarySigsAltKm SummarySigsSenAspect;
global SummarySigsBodAzim SummarySigsProjArea SummarySigsAvgTemp;
global SummarySigsEarthSA SummarySigsEarthBiStatAng SummarySigsSolarBiStatAng;
global SummarySigsInBand SummarySigsBandList;
global sumarysigspath;
global iloadedBandSigsFile iloadedSumarySigsFile;
global OSCInpFile;
global BBTable iloadedBandRatios;
global NumOSCBands OSCWaveLL OSCWaveUL;
global SumaryTrajData iSumryTrajData;

global CalcPosENUx CalcPosENUy CalcPosENUz;
global CalcVelENUx CalcVelENUy CalcVelENUz;
global CalcAccelENUx CalcAccelENUy CalcAccelENUz;
global DiffENUx DiffENUy DiffENUz;
global DiffENUVelx DiffENUVely DiffENUVelz;
global DiffENUAccelx DiffENUAccely DiffENUAccelz;
global CalcTimes CalcSlantRangeKM CalcSenAspect TrueTgtAspect;
global bstfile ecisenfile ecitgtfile sumrysigfile sumrytrajfile;

global initialtimestr igrid ilog imovie;
global legendstr1 legendstr2 legendstr3;
global fid fid2 fid3;
global vert1 hor1 widd lend;
global vert2 hor2 widd2 lend2 machine;
global chart_time;
global Fz1 Fz2;
global idirector mov izoom iwindow;
global matpath excelpath bstpath jpegpath;
global summrytrjpath ascpath;
global ecisenspath ecitgtpath;

global ipowerpoint scaling stretching padding;
global ichartnum;
kft2m=304.8;
ft2m=.3048;
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
icase=5;
if(icase==1)
    excelpath='D:\Trajectories\OSC\Excel_Files\';
    matpath='D:\Trajectories\OSC\MAT_Files\';
    jpegpath='D:\Trajectories\OSC\Jpeg\';
    bstpath='F:\Signatures\F5\Output\RV\BST_Files\';
    sumarysigspath='F:\Signatures\F5\Output\RV\SUMRYSIG_Files\';
    summrytrjpath='F:\Signatures\F5\Output\RV\SUMRYTRJ_Files\';
    ecisenspath='F:\Signatures\F5\Output\RV\ECISENS_Files\';
    ecitgtpath='F:\Signatures\F5\Output\RV\ECITARG_Files\';
    bstfile='F5_RV-01-10Hz.bst';
    SumarySigsFile='F5_RV-01.SUMRYSIG';
    sumrytrajfile='F5_RV-01.SUMRYTRJ';
    ecisenfile='F5_RV-01.ECISENS';
    ecitgtfile='F5_RV-01.ECITARG';
    ScenarioID='F5';
elseif(icase==2)
    excelpath='D:\Trajectories\OSC\Excel_Files\';
    matpath='D:\Trajectories\OSC\MAT_Files\';
    jpegpath='D:\Trajectories\OSC\Jpeg\';
    bstpath='F:\Signatures\L128aD07P29\output\RV\BST_Files\';
    sumarysigspath='F:\Signatures\L128aD07P29\output\RV\SUMRYSIG_Files\';
    summrytrjpath='F:\Signatures\L128aD07P29\output\RV\SUMRYTRJ_Files\';
    ecisenspath='F:\Signatures\L128aD07P29\output\RV\ECISENS_Files\';
    ecitgtpath='F:\Signatures\L128aD07P29\output\RV\ECITARG_Files\';
    bstfile='L128aD07P29_rv_IR-s1174-0004.bst';
    SumarySigsFile='rv_s1174_04.SUMRYSIG';
    sumrytrajfile='rv_s1174_04.SUMRYTRJ';
    ecisenfile='rv_s1174_04.ECISENS';
    ecitgtfile='rv_s1174_04.ECITARG';
    ScenarioID='L128aD07P29-rv-04';
elseif(icase==3)
    excelpath='D:\Trajectories\OSC\Excel_Files\';
    matpath='D:\Trajectories\OSC\MAT_Files\';
    jpegpath='D:\Trajectories\OSC\Jpeg\';
    bstpath='F:\Signatures\L128aD07P29\output\RV\BST_Files\';
    sumarysigspath='F:\Signatures\L128aD07P29\output\RV\SUMRYSIG_Files\';
    summrytrjpath='F:\Signatures\L128aD07P29\output\RV\SUMRYTRJ_Files\';
    ecisenspath='F:\Signatures\L128aD07P29\output\RV\ECISENS_Files\';
    ecitgtpath='F:\Signatures\L128aD07P29\output\RV\ECITARG_Files\';
    bstfile='L128aD07P29_rv_IR-s1174-0003.bst';
    SumarySigsFile='rv_s1174_03.SUMRYSIG';
    sumrytrajfile='rv_s1174_03.SUMRYTRJ';
    ecisenfile='rv_s1174_03.ECISENS';
    ecitgtfile='rv_s1174_03.ECITARG';
    ScenarioID='L128aD07P29-rv-03';
elseif(icase==5)
    excelpath='D:\Trajectories\OSC\Excel_Files\';
    matpath='D:\Trajectories\OSC\MAT_Files\';
    jpegpath='D:\Trajectories\OSC\Jpeg\';
    bstpath='F:\Signatures\L128aD07P29\output\RV\BST_Files\';
    sumarysigspath='F:\Signatures\L128aD07P29\output\RV\SUMRYSIG_Files\';
    summrytrjpath='F:\Signatures\L128aD07P29\output\RV\SUMRYTRJ_Files\';
    ecisenspath='F:\Signatures\L128aD07P29\output\RV\ECISENS_Files\';
    ecitgtpath='F:\Signatures\L128aD07P29\output\RV\ECITARG_Files\';
    bstfile='L128aD07P29_rv_IR-s1174-0005.bst';
    SumarySigsFile='rv_s1174_05.SUMRYSIG';
    sumrytrajfile='rv_s1174_05.SUMRYTRJ';
    ecisenfile='rv_s1174_05.ECISENS';
    ecitgtfile='rv_s1174_05.ECITARG';
    ScenarioID='L128aD07P29-rv-05';
end
tic;
% Import the desired file
eval(['cd ' bstpath(1:length(bstpath)-1)]);
BSTData = importdata(bstfile,' ',0);
BSTTime=BSTData(:,1);
BSTECIx=BSTData(:,2)*kft2m;
BSTECIy=BSTData(:,3)*kft2m;
BSTECIz=BSTData(:,4)*kft2m;
BSTECIVx=BSTData(:,5)*ft2m;
BSTECIVy=BSTData(:,6)*ft2m;
BSTECIVz=BSTData(:,7)*ft2m;
BSTEulerPhi=BSTData(:,8);
BSTEulerTheta=BSTData(:,9);
BSTEulerPsi=BSTData(:,10);
numbst=length(BSTTime);
ab=1;
% Next read in the ECITARG File
eval(['cd ' ecitgtpath(1:length(ecitgtpath)-1)]);
ECITargData = importdata(ecitgtfile,' ',0);
TimeECITarg=ECITargData(:,1);
numtgtpts=length(TimeECITarg);
ECIP=zeros(numtgtpts,3);
ECIV=zeros(numtgtpts,3);
XBODI=zeros(numtgtpts,3);
YBODI=zeros(numtgtpts,3);
ZBODI=zeros(numtgtpts,3);
PITCHI=zeros(numtgtpts,1);
YAWI=zeros(numtgtpts,1);
ROLLI=zeros(numtgtpts,1);
ECIP(:,1)=ECITargData(:,2);
ECIP(:,2)=ECITargData(:,3);
ECIP(:,3)=ECITargData(:,4);
ECIV(:,1)=ECITargData(:,5);
ECIV(:,2)=ECITargData(:,6);
ECIV(:,3)=ECITargData(:,7);
XBODI(:,1)=ECITargData(:,8);
XBODI(:,2)=ECITargData(:,9);
XBODI(:,3)=ECITargData(:,10);
YBODI(:,1)=ECITargData(:,11);
YBODI(:,2)=ECITargData(:,12);
YBODI(:,3)=ECITargData(:,13);
ZBODI(:,1)=ECITargData(:,14);
ZBODI(:,2)=ECITargData(:,15);
ZBODI(:,3)=ECITargData(:,16);
PITCHI(:,1)=ECITargData(:,17);
YAWI(:,1)=ECITargData(:,18);
ROLLI(:,1)=ECITargData(:,19);
ab=2;
% Next Import the ECISENS File
eval(['cd ' ecisenspath(1:length(ecisenspath)-1)]);
ECISenData = importdata(ecisenfile,' ',0);
TimeECISen=ECISenData(:,1);
numsenpts=length(TimeECISen);
ECIPS=zeros(numsenpts,3);
ECIVS=zeros(numsenpts,3);
ECIPS(:,1)=ECISenData(:,2);
ECIPS(:,2)=ECISenData(:,3);
ECIPS(:,3)=ECISenData(:,4);
ECIVS(:,1)=ECISenData(:,5);
ECIVS(:,2)=ECISenData(:,6);
ECIVS(:,3)=ECISenData(:,7);
ab=3;
% Now import the SUMRYSIGS Data
Import_SumarySigs_File;
numsumrysigpts=length(SummarySigsTime);
ab=4;
% Now Import the SUMRYTRJ File
eval(['cd ' summrytrjpath(1:length(summrytrjpath)-1)]);
ImportOSCSumryTrajFile(sumrytrajfile)
ab=5;
SRTrue=SumaryTrajData{2,9};
TrueAsp=SumaryTrajData{2,13};
RollSen=SumaryTrajData{2,15};
% Now loop through the available points to calculate the Slant Range vs Time
CalcTime=zeros(numtgtpts,1);
SRCalc=zeros(numtgtpts,1);
LOS=zeros(numtgtpts,3);
CalcAsp=zeros(numtgtpts,1);
CalcRoll=zeros(numtgtpts,1);
ZAng=zeros(numtgtpts,1);
RollDiff=zeros(numtgtpts,2);
maxRoll=-400;
for n=1:numtgtpts
    nowTime=TimeECITarg(n,1);
    CalcTime(n,1)=nowTime;
    xDist=ECIP(n,1)-ECIPS(n,1);
    yDist=ECIP(n,2)-ECIPS(n,2);
    zDist=ECIP(n,3)-ECIPS(n,3);
    slantRange=sqrt((xDist^2) + (yDist^2) + (zDist^2));
    LOS(n,1)=-xDist/slantRange;
    LOS(n,2)=-yDist/slantRange;
    LOS(n,3)=-zDist/slantRange;
    SRCalc(n,1)=slantRange/1000;
% Get the dot product between the LOS vector and the x axis vector of
% the target from the ECITarg File
    ab=8;
    losnow=[LOS(n,1) LOS(n,2) LOS(n,3)];
    xbodnow=[XBODI(n,1) XBODI(n,2) XBODI(n,3)];
    ybodnow=[YBODI(n,1) YBODI(n,2) YBODI(n,3)];
    zbodnow=[ZBODI(n,1) ZBODI(n,2) ZBODI(n,3)];
    prod=dot(losnow,xbodnow);
    prod2=dot(losnow,ybodnow);
    prod4=dot(losnow,zbodnow);
    ZAng(n,1)=acosd(prod4);
%    prod2=dot(losnow,zbodnow);
    calcAspnow=acosd(prod);
    CalcAsp(n,1)=calcAspnow;
    calcAspnow2=calcAspnow;
    if(abs(prod>.99))
        calcAspnow2=89;
    end
    try
        prod3=prod2/abs(sind(calcAspnow2));
%        prod3=prod2;
    catch
        prod3=0;
    end
    if(abs(prod3>1))
        prod3=1;
    end
    nowRoll=acosd(prod3);
    if(nowRoll<0)
        nowRoll=nowRoll+360;
    end
    CalcRoll(n,1)=nowRoll;
    nowRollSens=RollSen(n,1);
    RollDiff(n,1)=nowRoll-nowRollSens;
    RollDiff(n,2)=ZAng(n,1);
    if(abs(nowRoll-nowRollSens)>5)
       ab=7; 
    else
       ab=8;
    end
    if(nowRoll>maxRoll)
        maxRoll=nowRoll;
    end
    ab=9;
end
% Now plot the True SR from the SUMRTRJ file vs the Calculated number
classification='Unclassified';
titlestr=strcat(ScenarioID,'-TrueVsCaclulatedSlantRange');
figstr=strcat(titlestr,'.jpg');
PlotTrueVsCalcSR(TimeECITarg,CalcTime,SRTrue,SRCalc,...
    classification,titlestr,figstr)
% Now plot the True Tgt Aspect from the SUMRYTRJ file vs the Calculated
% number
titlestr=strcat(ScenarioID,'-TrueVsCaclulatedTgtAsp');
figstr=strcat(titlestr,'.jpg');
PlotTrueVsCalcTgtAspect(TimeECITarg,CalcTime,TrueAsp,CalcAsp,...
    classification,titlestr,figstr)
titlestr=strcat(ScenarioID,'-CaclulatedTgtRoll');
figstr=strcat(titlestr,'.jpg');
PlotCalcRollAngleVsTime(TimeECITarg,CalcRoll,TimeECITarg,RollSen,...
    TimeECITarg,ZAng,classification,titlestr,figstr)
% PLot The RollSen angle vs time
titlestr=strcat(ScenarioID,'-RollSen');
figstr=strcat(titlestr,'.jpg');
PlotRollSenVsTime(TimeECITarg,RollSen,classification,titlestr,figstr)
% Now plot the difference between the calculated roll angle and rollsen vs
% time
titlestr=strcat(ScenarioID,'-TgtRollDiff');
figstr=strcat(titlestr,'.jpg');
PlotRollAngleDiffVsTime(TimeECITarg,RollDiff,TimeECITarg,ZAng,...
    classification,titlestr,figstr)
elapsed_time=toc;
dispstr=strcat('Run took-',num2str(elapsed_time),'-seconds');
disp(dispstr)