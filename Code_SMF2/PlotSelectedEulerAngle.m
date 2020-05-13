function PlotSelectedEulerAngle(Time1,Time2,Euler1,Euler2,iselect,...
    classification,titlestr,figstr)
% This routine will plot the selected Euler angle from two files for
% comparison purposes
%
% Written By Stephen Forczyk
% Created Oct 31,2012
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
ymin=-180;
ymax=180;
diff=Euler1-Euler2;
mediandiff=median(diff);
% Now plot the Two Euler Angles
% 
movie_figure1=figure('position',[hor1 vert1 widd lend]);
set(gcf,'MenuBar','none');
set(gca,'Position',[.16 .24 .70 .65]);
plot(Time1,Euler1,'b+',Time2,Euler2,'r.',Time1,diff,'g');

xlabel('Time-Sec','FontWeight','bold');
if(iselect==1)
    ylabel('Roll Ang-Deg','FontWeight','bold');
elseif(iselect==2)
    ylabel('Pitch Ang-Deg','FontWeight','bold');
elseif(iselect==3)
    ylabel('Yaw Ang-Deg','FontWeight','bold');
elseif(iselect==4)
    ylabel('Correctecd Yaw Ang-Deg','FontWeight','bold');
end
set(gca,'FontWeight','bold');
set(gca,'XLim',[xmin xmax]);
set(gca,'YLim',[ymin ymax]);

set(gca,'XGrid','On','YGrid','On');
ht=title(titlestr);
set(ht,'FontWeight','bold');
if(iselect<4)
    hl=legend('ECI Angle','ECR Angle','Difference','Location','NorthWest');
elseif(iselect==4)
    hl=legend('ECI Angle','Corrected ECR Angle','Difference','Location','NorthWest');
end
% Set up an axis for writing text on the movie
newaxesh=axes('Position',[0 0 1 1]);
set(newaxesh,'XLim',[0 1],'YLim',[0 1]);
tx1=.10;
ty1=.16;
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

if(ipowerpoint>0)
    eval(['cd ' powerpath(1:length(powerpath)-1)]);
    saveppt2(PowerPointFile,'figure',movie_figure1,'scale',scaling,'padding',padding)
end

close('all');
