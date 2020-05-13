function PlotENUPosDifferences(titlestr,figstr)
% This routine will plot the asc file ENU position differences
% from Matlab calculated values
% Written By Stephen Forczyk
% Created March 09,2019
% Revised---
% Classification: Unclassified
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
runtimestr=datestr(now);

xmin1=min(ASCTimes);
xmax1=max(ASCTimes);
xmin=xmin1-mod(xmin1,100);
xmax=xmax1-mod(xmax1,100)+10;
ymin1=min(DiffENUx);
ymax1=max(DiffENUx);
ymin2=min(DiffENUy);
ymax2=max(DiffENUy);
ymin3=min(DiffENUz);
ymax3=max(DiffENUz);
yminvec=[ymin1 ymin2 ymin3];
ymaxvec=[ymax1 ymax2 ymax3];
ymin4=min(yminvec);
ymax4=max(ymaxvec);
ymin4abs=abs(ymin4);
ymax4abs=abs(ymax4);
yscalemax=max(ymin4abs,ymax4abs);
nextpow10=ceil(log10(yscalemax));
ymax=10^nextpow10;
if(ymax<1)
    ymax=1;
end
ymin=-ymax;

% 
movie_figure1=figure('position',[hor1 vert1 widd lend]);
set(gcf,'MenuBar','none');
set(gca,'Position',[.16 .24 .70 .65]);
plot(ASCTimes,DiffENUx,'b+',ASCTimes,DiffENUy,'r.',ASCTimes,DiffENUy,'g');

xlabel('Time-Sec','FontWeight','bold');
ylabel('Position Differences-meters','FontWeight','bold');

set(gca,'FontWeight','bold');
set(gca,'XLim',[xmin xmax]);
set(gca,'YLim',[ymin ymax]);

set(gca,'XGrid','On','YGrid','On');
ht=title(titlestr);
set(ht,'FontWeight','bold');
hl=legend('ENU X Pos','ENU Y Pos','ENU Z Pos','Location','NorthWest');

% Set up an axis for writing text on the movie
newaxesh=axes('Position',[0 0 1 1]);
set(newaxesh,'XLim',[0 1],'YLim',[0 1]);
tx1=.10;
ty1=.16;
txtstr1=strcat('Chart Creation Date-',runtimestr);
txt1=text(tx1,ty1,txtstr1,'FontWeight','bold','FontSize',8);
% tx2=.45;
% ty2=.95;
% txt2=text(tx2,ty2,classification,'FontWeight','bold','FontSize',8,'Color',[1 0 0]);
% tx3=.45;
% ty3=.03;
% txt3=text(tx3,ty3,classification,'FontWeight','bold','FontSize',8,'Color',[1 0 0]);

set(newaxesh,'Visible','Off');
pause(chart_time)
% Save the first chart
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);

% if(ipowerpoint>0)
%     eval(['cd ' powerpath(1:length(powerpath)-1)]);
%     saveppt2(PowerPointFile,'figure',movie_figure1,'scale',scaling,'padding',padding)
% end

close('all');
