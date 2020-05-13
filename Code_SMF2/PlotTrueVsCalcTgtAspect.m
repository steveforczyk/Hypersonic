function PlotTrueVsCalcTgtAspect(Time1,Time2,TrueAsp,CalcAsp,...
    classification,titlestr,figstr)
% This routine will plot the true and calculated target aspect
% angle wrt sensor vs time
% Written By Stephen Forczyk
% Created May 5,2019
% Revised---
% Classification: Unclassified


global initialtimestr runtimestr;
global hor1 vert1 widd lend;
global chart_time;
global jpegpath powerpath;
global matpath datastub;
global ipowerpoint PowerPointFile scaling stretching padding;
runtimestr=datestr(now);

xmin1=min(Time1);
xmax1=max(Time1);
xmin=xmin1-mod(xmin1,100);
xmax=xmax1-mod(xmax1,100)+10;
yvec1=[min(TrueAsp) min(CalcAsp)];
yvec2=[max(TrueAsp) max(CalcAsp)];
ymin1=min(yvec1);
ymax1=max(yvec2);
ymin=ymin1-mod(ymin1,100);
ymax=ymax1-mod(ymax1,100)+100;
diff=TrueAsp-CalcAsp;
mediandiff=median(diff);
% Now plot the Aspect Angle Value
% 
movie_figure1=figure('position',[hor1 vert1 widd lend]);
set(gcf,'MenuBar','none');
set(gca,'Position',[.16 .24 .70 .65]);
plot(Time1,TrueAsp,'b',Time2,CalcAsp,'r');

xlabel('Time-Sec','FontWeight','bold');
ylabel('TargetAspect Deg','FontWeight','bold');

set(gca,'FontWeight','bold');
set(gca,'XLim',[xmin xmax]);
set(gca,'YLim',[ymin ymax]);

set(gca,'XGrid','On','YGrid','On');
ht=title(titlestr);
set(ht,'FontWeight','bold');
hl=legend('TrueAsp','CalcAsp','Location','NorthWest');

% Set up an axis for writing text on the movie
newaxesh=axes('Position',[0 0 1 1]);
set(newaxesh,'XLim',[0 1],'YLim',[0 1]);
tx1=.10;
ty1=.12;
txtstr1=strcat('Chart Creation Date-',runtimestr,'-median difference value=',...
    num2str(mediandiff,6));
txt1=text(tx1,ty1,txtstr1,'FontWeight','bold','FontSize',8);
tx2=.45;
ty2=.95;
txt2=text(tx2,ty2,classification,'FontWeight','bold','FontSize',8,'Color',[1 0 0]);
tx3=.45;
ty3=.03;
txt3=text(tx3,ty3,classification,'FontWeight','bold','FontSize',8,'Color',[1 0 0]);

set(newaxesh,'Visible','Off');

pause(chart_time)
% Save the first chart
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);



close('all');
