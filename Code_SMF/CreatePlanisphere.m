function CreatePlanisphere(t,LatSSP,LongSSP,titlestr,figstr)
% This function will create a 2D map of the world projected onto an image
% Inspired by the code Orbit3D Author:Ennio.Condoleo.Date:2013.11.21.h:00.26
% Written By: Stephen Forczyk
% Created: June 29,2019
% Revised: -----------
% Classification: Unclassified
global hor1 vert1 widd lend;
global jpegpath;
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
%    planisphere = figure('Name','Planisphere');
planisphere=figure('Name','Planisphere','position',[hor1 vert1 widd lend]);
hold on;
set(gcf,'MenuBar','none');
set(gca,'XTick',[-180  -150  -120  -90 -75 -60 -45 -30 -15 0 ...
        15 30 45 60 75 90  120 150  180],'XTickMode','manual');
set(gca,'YTick',[-90 -75 -60 -45 -30 -15 0 15 30 45 60 75 90],'YTickMode','manual');
map=1;
trt=1;
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
        for j=2:size(t,1)                 % cycle for plotting one orbit
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
    else
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
    end
    ht=title(titlestr);
    eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
    actionstr='print';
    typestr='-djpeg';
    [cmdString]=MyStrcat2(actionstr,typestr,figstr);
    eval(cmdString);
    dispstr=strcat('saved plot to file=',figstr);
    disp(dispstr)
end


