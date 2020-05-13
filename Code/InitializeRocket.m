% This script will initialize the rocket routine found on P360 of
% Ashish Twerari's book "Atmospheric and space flight dynamics"

global dtr mu omega S c rm rtd; 
global tb1 tb2 fT1 fT2 m01 m02; 
global mL mp1 mp2 Gamma State f8; 
global mass drag mach Qdot D Qinf;
global CLH;

global widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;
global vert2 hor2 machine;
global Fz1 Fz2;
global jpegpath;
global chart_time;
dtr = pi/180;
rtd=1/dtr;
mu = 3.986004e14;
omega = 2*pi/(23*3600+56*60+4.0905);
S = 4;
c=0.5;
rm =  6378140;
o=zeros(6,1);
chart_time=5;
igrid=1;
icase=1;
if(icase==1)
    m01=16528.420;
    m02=7046.715;
    fT1=346017.7314;
    fT2=249640.1712;
    tb1=50;
    tb2=87.5;
    mL=350;
    mp1=8817.985;
    mp2=6361.880; 
    o(1,1)=-80.55*dtr;
    o(2,1)=28.5*dtr;
    o(3,1)=rm;
    o(4,1)=0;
    o(5,1)=90*dtr;
    o(6,1)=170*dtr;
    nsteps=10000;
    delt=.1;
    State=zeros(nsteps,14);
    filename='Case1.txt';
    CaseID='Case1-';
    jpegpath='D:\Forczyk\Hypersonic\Jpeg_Files\';
end
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
end
% Check if the user has access to the statistics toolbox
statistics_toolbox=license('test','statistics_toolbox');
signal_toolbox=license('test','signal_toolbox');
set(0,'DefaultAxesColorOrder',[1 0 0;
    1 1 0;0 1 0;0 0 1;0.75 0.50 0.25;
    0.5 0.75 0.25; 0.25 1 0.25;0 .50 .75]);
scaling='true';
stretching='false';
padding=[75 75 75 75];
[hor1,vert1,Fz1,Fz2,machine]=SetScreenCoordinates(widd,lend);
[hor2,vert2,Fz1,Fz2,machine]=SetScreenCoordinates(widd2,lend2);
chart_time=5;
f8=fopen(filename,'w');
for n=1:nsteps
    nowTime=(n-1)*delt;
    deriv = rocket(nowTime,o);
%    deriv = [longidot; latidot; raddot; veldot; gammadot; headdot];
    long=o(1,1);
    lat=o(2,1);
    rad=o(3,1);
    vel=o(4,1);
    gamma=o(5,1);
    head=o(6,1);
    o(1,1)=long+deriv(1,1)*delt;
    o(2,1)=lat+deriv(2,1)*delt;
    o(3,1)=rad+deriv(3,1)*delt;
    o(4,1)=vel+deriv(4,1)*delt;
    o(5,1)=gamma+deriv(5,1)*delt;
    o(6,1)=head+deriv(6,1)*delt;
    State(n,1)=nowTime;
    State(n,2)=o(1,1)*rtd;
    State(n,3)=o(2,1)*rtd;
    State(n,4)=(o(3,1)-rm)/1000;
    State(n,5)=o(4,1)/1000;
    State(n,6)=o(5,1)*rtd;
    State(n,7)=o(6,1)*rtd;
    State(n,8)=mass;
    State(n,9)=mach;
    State(n,10)=Qdot;
% Get the Rotation Matrix to calculate the orientation of
% The local horizontal frame relative to the Cartersian frame
%    CLH=zeros(3,3);
    lambda=State(n,2)*dtr;
    delta=State(n,3)*dtr;
    vel=o(4,1);
    rnow=o(3,1);
    phi=o(5,1);
%     CLH(1,1)=cos(delta)*cos(lambda);
%     CLH(1,2)=cos(delta)*sin(lambda);
%     CLH(1,3)=sin(delta);
%     CLH(2,1)=-sin(lambda);
%     CLH(2,2)=cos(lambda);
%     CLH(2,3)=0;
%     CLH(3,1)=-sin(delta)*cos(lambda);
%     CLH(3,2)=-sin(delta)*sin(lambda);
%     CLH(3,3)=cos(delta);
      AzRel=State(n,7)*dtr;
      tanAInert=tan(AzRel)-(omega*rnow*cos(delta))/(vel*cos(phi)*(cos(AzRel)));
      AzInert=atan(tanAInert);
      tanphiInert=tan(phi)*cos(AzInert)/cos(AzRel);
      phiInert=atan(tanphiInert);
      vInert=vel*sin(phi)/sin(phiInert);
      State(n,11)=AzInert*rtd;
      State(n,12)=phiInert*rtd;
      State(n,13)=vInert*rtd;
      State(n,14)=Qinf;
    ab=2;
end
fclose(f8);
% Now plot the Time vs Altitude
Time=State(:,1);
Alt=State(:,4);
VRelSpeed=State(:,5);
FPARel=State(:,6);
Heading=State(:,7);
MassRemain=State(:,8);
MachNum=State(:,9);
QDot=State(:,10);
DynPressure=State(:,14);
titlestr=strcat(CaseID,'TimeVsAlt');
figstr=strcat(titlestr,'.jpg');
PlotRocketTimeVsAlt(Time,Alt,titlestr,figstr)
titlestr=strcat(CaseID,'TimeVsVRelSpeed');
figstr=strcat(titlestr,'.jpg');
PlotRocketTimeVsVRel(Time,VRelSpeed,titlestr,figstr)
titlestr=strcat(CaseID,'MachNumVsAlt');
figstr=strcat(titlestr,'.jpg');
PlotRocketMachNumVsAlt(Alt,MachNum,titlestr,figstr)
titlestr=strcat(CaseID,'QDotVsAlt');
figstr=strcat(titlestr,'.jpg');
PlotRocketQDotVsAlt(Alt,QDot,titlestr,figstr);
titlestr=strcat(CaseID,'TimeVsFlightPathAng');
figstr=strcat(titlestr,'.jpg');
PlotRocketTimeVsFPA(Time,FPARel,titlestr,figstr);
titlestr=strcat(CaseID,'TimeVsFlightMassRemaining');
figstr=strcat(titlestr,'.jpg');
PlotRocketTimeVsMassRemain(Time,MassRemain,titlestr,figstr)
titlestr=strcat(CaseID,'TimeVsHeading');
figstr=strcat(titlestr,'.jpg');
PlotRocketTimeVsHeading(Time,Heading,titlestr,figstr)
titlestr=strcat(CaseID,'DynPressureVsAlt');
figstr=strcat(titlestr,'.jpg');
PlotRocketDynPressureVsAlt(Alt,DynPressure,titlestr,figstr);
disp('Run Finished')