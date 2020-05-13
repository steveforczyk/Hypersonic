function PlotTargetAspectVsTime(Time1,Time2,TrueAspect,CalculatedAspect,...
    classification,titlestr,figstr)
% This routine will plot true aspect as determine by Umpire vs 
% the calculated aspect
%
% Written By Stephen Forczyk
% Created May 2,2019
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
xmin=xmin1-mod(xmin1,10);
xmax=xmax1-mod(xmax1,10)+10;
ymin=-180;
ymax=180;
diff=abs(TrueAspect-CalculatedAspect);
mediandiff=median(diff);
% Now plot the Aspect Values
% 
movie_figure1=figure('position',[hor1 vert1 widd lend]);
set(gcf,'MenuBar','none');
set(gca,'Position',[.16 .24 .70 .65]);
plot(Time1,TrueAspect,'r',Time2,CalculatedAspect,'b');

xlabel('Time-Sec','FontWeight','bold');
ylabel('Tgt Aspect-Deg','FontWeight','bold');

set(gca,'FontWeight','bold');
set(gca,'XLim',[xmin xmax]);
set(gca,'YLim',[ymin ymax]);

set(gca,'XGrid','On','YGrid','On');
ht=title(titlestr);
set(ht,'FontWeight','bold');
hl=legend('True Tgt Aspect','Calculated Tgt Aspect','Location','NorthWest');

% Set up an axis for writing text on the movie
newaxesh=axes('Position',[0 0 1 1]);
set(newaxesh,'XLim',[0 1],'YLim',[0 1]);
tx1=.10;
ty1=.16;
txtstr1=strcat('Chart Creation Date-',runtimestr,'-median difference value =',...
    num2str(mediandiff,6),'-deg');
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

% if(ipowerpoint>0)
%     eval(['cd ' powerpath(1:length(powerpath)-1)]);
%     saveppt2(PowerPointFile,'figure',movie_figure1,'scale',scaling,'padding',padding)
% end

close('all');
