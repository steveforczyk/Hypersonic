function PlotRocketTimeMassRemain(Time,MassRemain,titlestr,figstr)
% This routine will plot the rocket mass remaining  vs time
% Written By: Stephen Forczyk
% Created: August 14,2019
% Revised: -----
% Classification: Unclassified
global TabName;

global vert1 hor1 widd lend;
global vert2 hor2 lend2 machine;
global chart_timel
global Fz1 Fz2 chart_time;
global idirector igrid;
global matpath moviepath;
global jpegpath powerpath;
global ipowerpoint PowerPointFile scaling stretching padding;

initialtimestr=datestr(now);
% Calculate the min and max values of Time and RelativeSpeed to set
% the plot limits

xmin=0;
xmax1=max(Time);
xmax=xmax1-mod(xmax1,100)+100;
ymin=0;
ymax1=maz(MassRemain);
ymaxpexp=nextpow2(ymax1);
ymax=2^ymaxpexp;
% Now plot the Rocket Mass Remaining Vs Time as a line plot
movie_figure1=figure('position',[hor1 vert1 widd lend]);
set(gcf,'MenuBar','none');
set(gca,'Position',[.16 .18  .70 .70]);
plot(Time,MassRemain,'g');
xlabel('Time-sec','FontWeight','bold');
ylabel('Rocket Masss-kg','FontWeight','bold');
set(gca,'XLim',[xmin xmax]);
set(gca,'YLim',[ymin ymax]);
set(gca,'FontWeight','bold');
if(igrid==1)
    set(gca,'XGrid','On','YGrid','On');
end
ht=title(titlestr);
set(ht,'FontWeight','bold');
% Set up the axis for writing at the bottom of the chart
% newaxesh=axes('Position',[0 0 1 1]);
% set(newaxesh,'XLim',[0 1],'YLim',[0 1]);
% tx1=.10;
% ty1=.10;
% txtstr1=levelstr
% txt1=text(tx1,ty1,levelstr,'FontWeight','bold','FontSize',10,'Color',...
%[1 0 0]);
pause(chart_time);
% Save this chart
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);
close('all');
dispstr=strcat('Saved file-',figstr);
disp(dispstr);

end

