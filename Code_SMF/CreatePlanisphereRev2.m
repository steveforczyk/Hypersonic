function CreatePlanisphereRev2(t,trt,nobj,titlestr,figstr)
% This function will create a 2D map of the world projected onto an image
% Inspired by the code Orbit3D Author:Ennio.Condoleo.Date:2013.11.21.h:00.26
% Revision aimed at moving some inputs to global variables and expanding
% map options
% Written By: Stephen Forczyk
% Created: March 10,2020
% Revised: ----
% Classification: Unclassified
global AimpointLat AimpointLon;
global LaunchpointLat  LaunchpointLon;
global LatSSP LongSSP;
global PropogatedTraj;
global ASC58ColData ReEntryAltLimit;
global BaseTraj;

global hor1 vert1 widd lend;
global jpegpath;
global chart_time;

[numobjp1,ncols]=size(PropogatedTraj);
numobj=numobjp1-1;
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
%    planisphere = figure('Name','Planisphere');
planisphere=figure('Name','Planisphere','position',[hor1 vert1 widd lend]);
hold on;
set(gcf,'MenuBar','none');
set(gca,'XTick',[-180  -150  -120  -90 -75 -60 -45 -30 -15 0 ...
        15 30 45 60 75 90  120 150  180],'XTickMode','manual');
set(gca,'YTick',[-90 -75 -60 -45 -30 -15 0 15 30 45 60 75 90],'YTickMode','manual');
map=1;
%trt=1;
switch lower(map)
        case '1'
            image_file = 'land_ocean_ice_2048.jpg';
            cdata      = imread(image_file);
            imagesc([-180,180],[90,-90],cdata);
        case '2'
            image_file = 'land_par_mer.jpg';
            cdata      = imread(image_file);
            imagesc([-180,180],[90,-90],cdata);
        otherwise
            % Load the properties for plotting the planisphere
            load('topo.mat','topo','topomap1');               
            load coast;                                       
            plot(long,lat,'b','LineWidth',1.2); 
    end

    grid on;
    axis([-180 180 -90 90]);
    plot([-180 180],[0 0],'--k','LineWidth',1.5);  % Equator
    if (trt==1)
        plot(LongSSP(1),LatSSP(1),'go','MarkerSize',2,'MarkerFaceColor',[0 1 0],...   % Departure
                    'MarkerEdgeColor','g');
        for j=2:size(t,1)                 % 
%             if (t(j)-t0<=T+step)
                plot(LongSSP(j),LatSSP(j),'ro','MarkerSize',1,'MarkerFaceColor',[0.8 0.2 0.1],...
                    'MarkerEdgeColor','r');
                pause(0.01);
                if (j>1)
                    if ((abs(LongSSP(j)-LongSSP(j-1))<160)&&(abs(LatSSP(j)-LatSSP(j-1))<135))
                        plot([LongSSP(j-1),LongSSP(j)],[LatSSP(j-1),LatSSP(j)],'-r',...
                            'LineWidth',1.5);
                    end
                end
%            end
        end
        plot(LongSSP(end),LatSSP(end),'ko','MarkerSize',2,'MarkerFaceColor',[0 0 0],...   % End
                    'MarkerEdgeColor','w');
        
                plot(AimpointLon,AimpointLat,'x','MarkerSize',10,'MarkerFaceColor',[1 0 0],...   % Aimpoint
                    'MarkerEdgeColor','r');
    elseif(trt==2)
        plot(LongSSP(1),LatSSP(1),'go','MarkerSize',6,'MarkerFaceColor',[0 1 0],...   % Departure
                    'MarkerEdgeColor','g');
        for j=2:size(t,2)                 % cycle for plotting all orbits
            plot(LongSSP(j),LatSSP(j),'ro','MarkerSize',1,'MarkerFaceColor',[0.8 0.2 0.1],...
                    'MarkerEdgeColor','r');
            pause(0.02);
            if (j>1)
                if (abs(LongSSP(j)-LongSSP(j-1))<80)
                    plot([LongSSP(j-1),LongSSP(j)],[LatSSP(j-1),LatSSP(j)],'-r',...
                        'LineWidth',1.5);
                end
            end
        end
        plot(LongSSP(end),LatSSP(end),'rd','MarkerSize',6,'MarkerFaceColor',[0 0 0],...   % End
                    'MarkerEdgeColor','w');
    elseif(trt==3)
       plot(LongSSP,LatSSP,'rd','MarkerSize',6,'MarkerFaceColor',[0 0 0],...   % End
                    'MarkerEdgeColor','r');
       hold on
       plot(LongSSP(1),LatSSP(1),'bd','MarkerSize',6,'MarkerFaceColor',[0 0 0],...   % End
                    'MarkerEdgeColor','b');
       plot(LongSSP(end),LatSSP(1),'gs','MarkerSize',8,'MarkerFaceColor',[0 0 0],...   % End
                    'MarkerEdgeColor','g');
       hold off
       
    elseif (trt==4)% Plot true trajectory alongside of propogated trajectory
        plot(LongSSP(1),LatSSP(1),'ro','MarkerSize',2,'MarkerFaceColor',[1 0 0],...   % Departure
                    'MarkerEdgeColor','g');
        numplotpts=length(t);
        for j=2:numplotpts                
                plot(LongSSP(j),LatSSP(j),'r-','MarkerSize',1,'MarkerFaceColor',[0.8 0.2 0.1],...
                    'MarkerEdgeColor','r');
                pause(0.01);
                if (j>1)
                    if ((abs(LongSSP(j)-LongSSP(j-1))<160)&&(abs(LatSSP(j)-LatSSP(j-1))<135))
                        plot([LongSSP(j-1),LongSSP(j)],[LatSSP(j-1),LatSSP(j)],'-r',...
                            'LineWidth',1.5);
                    end
                end
        end
        plot(LongSSP(end),LatSSP(end),'r+','MarkerSize',2,'MarkerFaceColor',[1 0 0],...   % End
                    'MarkerEdgeColor','w');
        plot(AimpointLon,AimpointLat,'x','MarkerSize',10,'MarkerFaceColor',[1 0 0],...   % Aimpoint
                    'MarkerEdgeColor','r');
        plot(LaunchpointLon,LaunchpointLat,'+','MarkerSize',10,'MarkerFaceColor',[1 0 0],...   % Aimpoint
                    'MarkerEdgeColor','r');
% Retrieve the truth data for this object
        PlotTimes=ASC58ColData{1+nobj,1};
        PlotLat=ASC58ColData{1+nobj,54};
        PlotLon=ASC58ColData{1+nobj,55};
        plot(PlotLon,PlotLat,'g.','MarkerSize',2,'MarkerFaceColor',[0 1 0],...   % Departure
                    'MarkerEdgeColor','b');
                
     elseif (trt==5)% Plot the baseline trajectory and the predicted impact points of
%       those objects that could be projected that far ahead
        plot(BaseTraj(:,4),BaseTraj(:,3),'r.','MarkerSize',2,'MarkerFaceColor',[1 0 0],...   % Base Traj
                    'MarkerEdgeColor','g');
        hold on
% Now cycle through the objects that were propogated and plot their
% projected impact points  
        for m=1:numobj
            nowLat=PropogatedTraj{1+m,22};
            nowLon=PropogatedTraj{1+m,23};
            nowObj=PropogatedTraj{1+m,3};
            impact_flag=PropogatedTraj{1+m,19};
            if(impact_flag==1)
                plot(nowLon,nowLat,'g+','MarkerSize',2,'MarkerFaceColor',[0 1 0],...   % ImpactPoint
                    'MarkerEdgeColor','b');
                dispstr=strcat('Plotted obj#-',num2str(m),'-which is-',nowObj,...
                    '-impact Lat=',num2str(nowLat),'-impact Lon=',num2str(nowLon));
                disp(dispstr)
            end
        end
        hold off
   elseif (trt==6)% Plot the predicted trajectory
 % Retrieve the truth data for this object
        PlotTimes=ASC58ColData{1+nobj,1};
        PlotLat=ASC58ColData{1+nobj,54};
        PlotLon=ASC58ColData{1+nobj,55};
        plot(PlotLon,PlotLat,'g.','MarkerSize',2,'MarkerFaceColor',[0 1 0],...   % True Traj
                    'MarkerEdgeColor','g');
        hold on
        plot(LongSSP,LatSSP,'r.','MarkerSize',2,'MarkerFaceColor',[1 0 0],...   % propogated traj
                    'MarkerEdgeColor','r');
        hold off
% Now cycle through the objects that were propogated and plot their
% projected impact points  
%         for m=1:numobj
%             nowLat=PropogatedTraj{1+m,22};
%             nowLon=PropogatedTraj{1+m,23};
%             nowObj=PropogatedTraj{1+m,3};
%             impact_flag=PropogatedTraj{1+m,19};
%             if(impact_flag==1)
%                 plot(nowLon,nowLat,'g+','MarkerSize',2,'MarkerFaceColor',[0 1 0],...   % ImpactPoint
%                     'MarkerEdgeColor','b');
%                 dispstr=strcat('Plotted obj#-',num2str(m),'-which is-',nowObj,...
%                     '-impact Lat=',num2str(nowLat),'-impact Lon=',num2str(nowLon));
%                 disp(dispstr)
%             end
%         end
%         hold off    
    end
    ht=title(titlestr);
    eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
    actionstr='print';
    typestr='-djpeg';
    [cmdString]=MyStrcat2(actionstr,typestr,figstr);
    eval(cmdString);
    dispstr=strcat('saved plot to file=',figstr);
    disp(dispstr)
    pause(chart_time);
    close('all');
end


