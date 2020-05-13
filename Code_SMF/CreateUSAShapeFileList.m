% This script will import an Excel Spreadsheet with shapefile data
% and turn this into a .mat file to be used with MakeDetailedMapVer8
% Written By: Stephen Forczyk
% Created: April 25,2020
% Revised: ------

% Classification: Unclassified
clear all
clc
global MDACountry MDALat MDALon;
global MDAName MDAType MDATypeCode;
global ExcelFile MatFile TabName;
global USAStatesShapeFileList;

global widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;
global vert2 hor2 machine;
global chart_time;
global Fz1 Fz2;
global idirector mov izoom iwindow;
global matpath saberpath moviepath matpath1;
global jpegpath  topopath countrypath militarypath;
global statepath canadapath divapath;
global trajpath powerpath excelpath;
global tiffpath shapepath shapepath2;
global ipowerpoint PowerPointFile scaling stretching padding;

icase=1;
if(icase==1)% Baseline with renamed categories
    matpath='D:\Forczyk\Map_Data\MAT_Files_Geographic\';
    excelpath='F:\MDSET\Osborn\Excel_Files\';
    ExcelFile='USAMapListRev3.xlsx';
    MatFile='USAStatesShapeFileMapListRev3.mat';
    TabName='ShapeFiles';
end
% Establish selected run parameters
imachine=3;
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
chart_time=1;
idirector=1;
runtimestr=datestr(now);
tic;
% Navigate to the location of the Excel File
eval(['cd ' excelpath(1:length(excelpath)-1)]);
[num,USAStatesShapeFileList,raw]=xlsread(ExcelFile,TabName);
[nrows,ncols]=size(raw);
% for n=1:nrows
%     if(n==1)
%         MDAName=raw{n,1};
%         MDACountry=raw{n,2};
%         MDAType=raw{n,3};
%     else
%         MDAName=strvcat(MDAName,raw{n,1});
%         MDACountry=strvcat(MDACountry,raw{n,2});
%         MDAType=strvcat(MDAType,raw{n,3});
%     end
%     MDALat(n,1)=raw{n,4};
%     MDALon(n,1)=raw{n,5};
%     MDATypeCode(n,1)=raw{n,6};
% end
eval(['cd ' matpath(1:length(matpath)-1)]);
actionstr='save';
varstr='USAStatesShapeFileList';
[cmdString]=MyStrcat(actionstr,MatFile,varstr);
eval(cmdString)
dispstr=strcat('Wrote USAStatesShapeFileList File-',MatFile);
disp(dispstr);

elapsed_time=toc;
dispstr=strcat('Run took-',num2str(elapsed_time,5),'-sec');
disp(dispstr)
