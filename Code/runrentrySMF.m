% Copyright Ashish Tewari (c) 2006
% Added plot routines Stephen Forczyk
% Added creation of Excel File
% Created: March 27,2020
% Revised:-----
% Classification: Unclassified
global ExcelFileName
global dtr; 
global mu; 
global S; 
global c; 
global m; 
global rm; 
global omega; 
global Gamma;  

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
global f8;
jpegpath='D:\Forczyk\Hypersonic\Jpeg2\';
excelpath='D:\Forczyk\Hypersonic\Excel_Files\';
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
dtr = pi/180;
mu = 3.986004e14;
S = 4;
c=0.5;
m =  350;
rm = 6378140;
omega = 2*pi/(23*3600+56*60+4.0905);
Gamma=1.41;
f8 = fopen('data8.mat', 'a');
BaseName='TestCase-';
tic;
%toffset=0;
% long = -10*dtr;            
% lat = -79.8489182889*dtr; 
% rad= 6579.89967e3;  
% vel= 7589.30433867; 
% fpa= 0.54681217*dtr;
%chi= 99.955734*dtr; 
%end_time=1750;
toffset=958;
long=-0.5758;
lat=1.1542;
rad=7.1916E6;
vel=6.3019E3;
fpa=0.0017;
chi=4.2643;
end_time=800;
options = odeset('RelTol', 1e-8);    
orbinit = [long; lat; rad; vel; fpa; chi]; 
tspan=1:2:end_time;
 %orbinit = [-0.5758;1.1542; 7.1916e+06;6.3019e+03;0.0017; 4.2643]; 
%[t, o] = ode45('reentry',[0, end_time],orbinit,options);
[t, o] = ode45('reentry',tspan,orbinit,options);
numvals=length(t);
fclose('all');
% Now plot the Altitude vs time
TimeS=t+toffset;
PlotAlt=(o(:,3)-rm)/1000;
titlestr=strcat(BaseName,'AltVsTime');
figstr=strcat(titlestr,'.jpg');
PlotOutputAltVsTime(TimeS,PlotAlt,titlestr,figstr)
% Now plot the longitude vs time
PlotLon=o(:,1)/dtr;
titlestr=strcat(BaseName,'LonVsTime');
figstr=strcat(titlestr,'.jpg');
PlotOutputLonVsTime(TimeS,PlotLon,titlestr,figstr)
% Now plot the latitude vs time
PlotLat=o(:,2)/dtr;
titlestr=strcat(BaseName,'LatVsTime');
figstr=strcat(titlestr,'.jpg');
PlotOutputLatVsTime(TimeS,PlotLat,titlestr,figstr)
% Now plot the velocity vs time
PlotVel=o(:,4)/1000;
titlestr=strcat(BaseName,'VelVsTime');
figstr=strcat(titlestr,'.jpg');
PlotOutputVelVsTime(TimeS,PlotVel,titlestr,figstr)
% Plot the flight path angle vs time
PlotFPA=o(:,5)/dtr;
titlestr=strcat(BaseName,'FPAVsTime');
figstr=strcat(titlestr,'.jpg');
PlotOutputFPAVsTime(TimeS,PlotFPA,titlestr,figstr)
% Plot the Heading angle vs time
PlotHeading=o(:,6)/dtr;
titlestr=strcat(BaseName,'HeadingVsTime');
figstr=strcat(titlestr,'.jpg');
PlotOutputHeadingVsTime(TimeS,PlotHeading,titlestr,figstr)
elapsed_time=toc;
dispstr=strcat('Run took-',num2str(elapsed_time),'-seconds to calculate-',...
    num2str(numvals),'-trajectory points');
disp(dispstr)
