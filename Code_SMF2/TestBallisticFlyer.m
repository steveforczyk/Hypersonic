% This script will test a ballistic flier based on a Runge Kutta
% Integration of an ECI state vector
% Written By: Stephen Forczyk
% Created: Mar 12,2019
% Revised:-----
% Classification: Unclassified
global ExcelFileName ExcelTab;

global initialtimestr igrid ilog imovie;
global legendstr1 legendstr2 legendstr3;
global fid fid2 fid3;
global vert1 hor1 widd lend;
global vert2 hor2 widd2 lend2 machine;
global chart_time;
global Fz1 Fz2;
global idirector mov izoom iwindow;
global matpath matpath1 moviepath;
global jpegpath  reportpath;
global datapath powerpath excelpath;
global tiffpath oscpath;
global ipowerpoint PowerPointFile scaling stretching padding;
global statistics_toolbox;
global ichartnum;

icase=1;
if(icase==1)
    excelpath='H:\MDSET\Trajectories\Excel_Files\';
    jpegpath='H:\MDSET\Trajectories\Jpeg_Files\';
    state0(1,1)=-4577666.425609;
    state0(2,1)=1574500.146106;
    state0(3,1)=4868278.444860;
    state0(4,1)=-1533.231352;
    state0(5,1)=-5136.475129;
    state0(6,1)=1466.012559;
    tol=1E-6;
    talo=500;
    tspan(1,1)=0;
    tspan(2,1)=100;
end
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
classification='Secret';
tic;
% Now call the propagator
% tspan(1,1)=0;
% tspan(2,1)=10;
[times,state,covar] = ballistic_flier(state0,tspan,tol);
numtimes=length(times);
ecicalc=zeros(numtimes,7);
for n=1:numtimes
    ecicalc(n,1)=times(n,1)+talo;
    ecicalc(n,2)=state(1,n);
    ecicalc(n,3)=state(2,n);
    ecicalc(n,4)=state(3,n);
    ecicalc(n,5)=state(4,n);
    ecicalc(n,6)=state(5,n);
    ecicalc(n,7)=state(6,n);
end
% Convert this ecef
ecf=eci2ecf(ecicalc);
lla=ecf2lla(ecf);
ab=1;