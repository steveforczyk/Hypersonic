% This script will convert 58col files that were generated in the ECR
% coordinate system to the ECI system. This script was created because
% some of the 58 col trajectory files created by EIT used the ECR format
% but National Team downstream tools such as SABER want 58 col ECI
% coordinates
% 
% Written By: Stephen Forczyk
% Created: Nov3,2014
% Revised: Nov 4,2014 set up to work with files created by
%          a previous run of the script Parse58ColFiles

% Classification: Unclassified
global runID;
global loadedfiles;



global initialtimestr igrid ijpeg ilog imovie;
global legendstr1 legendstr2 legendstr3;
global fid fid2 fid3;
global vert1 hor1 widd lend;
global vert2 hor2 widd2 lend2 machine;
global chart_time;
global Fz1 Fz2;
global idirector mov izoom iwindow;

global topdir destdir sourcedir jpegpath excelpath;
global ipowerpoint PowerPointFile scaling stretching padding;
global statistics_toolbox signal_toolbox;
global ichartnum;

clc

loadedfiles=0;
ipowerpoint=0;
ijpeg=1;
icase=3;

if(icase==1)
    topdir='E:\AAT\Forczyk\Trajectories\Data\';
    jpegpath='E:\AAT\Forczyk\Trajectories\Jpeg\';
    [FileList] = getfilelist(topdir,'.asc','True');
    numfiles=length(FileList);
elseif(icase==2)
    topdir='E:\AAT\Forczyk\Trajectories\Data2\';
    jpegpath='E:\AAT\Forczyk\Trajectories\Jpeg2\';
    [FileList] = getfilelist(topdir,'.asc','True');
    numfiles=length(FileList);
elseif(icase==3)
    topdir='E:\AAT\Forczyk\Trajectories\Data3\L128cD03P35_IR1_Barrow_all_objects_ECR\';
    jpegpath='E:\AAT\Forczyk\Trajectories\Data3\L128cD03P35_IR1_Barrow_ECR\Jpeg\';
    excelpath='E:\AAT\Forczyk\Trajectories\Data3\L128cD03P35_IR1_Barrow_ECR\Excel_Files\';
    [FileList] = getfilelist(topdir,'.asc','True');
    numfiles=length(FileList);
elseif(icase==4)
    sourcedir='E:\AAT\Forczyk\Trajectories\Data3\L128cD03P35_IR1_Barrow_all\Parsed\L128cD03P35_IR1_Barrow_ME\';
    destdir='E:\AAT\Forczyk\Trajectories\Data3\L128cD03P35_IR1_Barrow_all\Parsed_ECI\L128cD03P35_IR1_Barrow_ME\';
    jpegpath='E:\AAT\Forczyk\Trajectories\Data3\L128cD03P35_IR1_Barrow_all\Jpeg\';
    excelpath='E:\AAT\Forczyk\Trajectories\Data3\L128cD03P35_IR1_Barrow_all\Excel_Files\';
    [FileList] = getfilelist(sourcedir,'.asc','True');
    numfiles=length(FileList);
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
igrid=1;
% Set up paramters for graphs that will center them on the screen
[hor1,vert1,Fz1,Fz2,machine]=SetScreenCoordinates(widd,lend);
[hor2,vert2,Fz1,Fz2,machine]=SetScreenCoordinates(widd2,lend2);
chart_time=1;
idirector=1;
initialtimestr=datestr(now);
classification='Secret';
levelstr=classification;
tic;
Results=cell(1,1);
Results{1,1}='Time';
Results{1,2}='GroundRange';
Results{1,3}='Altitude';
Results{1,4}='AngleofAttack';
Results{1,5}='FlightPathAng';
Results{1,6}='PrecessionCone';
Results{1,7}='Thrust';
Results{1,8}='CGAxial';
Results{1,9}='PositionECIx';
Results{1,10}='PositionECIy';
Results{1,11}='PositionECIz';
Results{1,12}='PositionENUx';
Results{1,13}='PositionENUy';
Results{1,14}='PositionENUz';
Results{1,15}='VelocityECIx';
Results{1,16}='VelocityECIy';
Results{1,17}='VelocityECIz';
Results{1,18}='VelocityENUx';
Results{1,19}='VelocityENUy';
Results{1,20}='VelocityENUz';
Results{1,21}='AccelECIx';
Results{1,22}='AccelECIy';
Results{1,23}='AccelECIz';
Results{1,24}='AccelENUx';
Results{1,25}='AccelENUy';
Results{1,26}='AccelENUz';
Results{1,27}='SensAccAxial';
Results{1,28}='SensAccNormal';
Results{1,29}='RollAngleECI';
Results{1,30}='PitchAngleECI';
Results{1,31}='YawAngleECI';
Results{1,32}='RollAngleENU';
Results{1,33}='PitchAngleENU';
Results{1,34}='YawAngleENU';
Results{1,35}='BodyRateAxial';
Results{1,36}='BodyRateY';
Results{1,37}='BodyRateZ';
Results{1,38}='BallisticCoeff';
Results{1,39}='Mass';
Results{1,40}='CPPitchPlane';
Results{1,41}='CPYawPlane';
Results{1,42}='Airspeed';
Results{1,43}='Ixx';
Results{1,44}='Iyy';
Results{1,45}='Izz';
Results{1,46}='TimeOfLiftoff';
Results{1,47}='MachNumber';
Results{1,48}='SensedAccelY';
Results{1,49}='SensedAccelZ';
Results{1,50}='DynamicPress';
Results{1,51}='PitchAoA';
Results{1,52}='YawAoA';
Results{1,53}='TimeLastState';
Results{1,54}='TargetLat';
Results{1,55}='TargetLong';
Results{1,56}='DragCoeff';
Results{1,57}='CMalphaSlope';
Results{1,58}='TALO';
Results{1,59}='FileName';
Results{1,60}='ECI Flag';
for n=1:numfiles
    filename=FileList{n,1};
    [islash]=strfind(filename,'\');
    numslash=length(islash);
    filelen=length(filename);
    is=islash(numslash)+1;
    ie=filelen;
    shortfilename=filename(is:ie);
% Get a shorter name to be used on the plot files
    [iper]=strfind(shortfilename,'.');
    is=1;
    ie=iper(1)-1;
    plotfilename=shortfilename(is:ie);
    [plotfilename]=RemoveUnderScores(plotfilename);
    dispstr=strcat('Now processing single object file-',shortfilename);
    disp(dispstr);
% Before attempting to import the file establish how many header records
% are present
    fid=fopen(filename,'r');
% keep reading this file until a line with periods is encountered-this is
% the first data record
    nheaders=0;
    idatafound=0;
    while (idatafound<1)
        tline=fgetl(fid);
        [iper]=strfind(tline,'.');
        numper=length(iper);
        if(numper<2)
            nheaders=nheaders+1;
            idatafound=0;
        else
            idatafound=1;
        end
    end
    fclose(fid);
    ab=1;
% Now import this file
    [Data]=LoadBMRD58Rev3(filename,nheaders);
    numvals=length(Data.Time);
    Traj=zeros(numvals,58);
    for m=1:numvals
        Traj(m,1)=Data.Time(m,1);
        Traj(m,2)=Data.GroundRange(m,1);
        Traj(m,3)=Data.Altitude(m,1);
        Traj(m,4)=Data.AngleofAttack(m,1);
        Traj(m,5)=Data.FlightPathAng(m,1);
        Traj(m,6)=Data.PrecessionCone(m,1);
        Traj(m,7)=Data.Thrust(m,1);
        Traj(m,8)=Data.CGAxial(m,1);
        Traj(m,9)=Data.PositionECIx(m,1);
        Traj(m,10)=Data.PositionECIy(m,1);
        Traj(m,11)=Data.PositionECIz(m,1);
        Traj(m,12)=Data.PositionENUx(m,1);
        Traj(m,13)=Data.PositionENUy(m,1);
        Traj(m,14)=Data.PositionENUz(m,1);
        Traj(m,15)=Data.VelocityECIx(m,1);
        Traj(m,16)=Data.VelocityECIy(m,1);
        Traj(m,17)=Data.VelocityECIz(m,1);
        Traj(m,18)=Data.VelocityENUx(m,1);
        Traj(m,19)=Data.VelocityENUy(m,1);
        Traj(m,20)=Data.VelocityENUz(m,1);
        Traj(m,21)=Data.AccelECIx(m,1);
        Traj(m,22)=Data.AccelECIy(m,1);
        Traj(m,23)=Data.AccelECIz(m,1);
        Traj(m,24)=Data.AccelENUx(m,1);
        Traj(m,25)=Data.AccelENUy(m,1);
        Traj(m,26)=Data.AccelENUz(m,1);
        Traj(m,27)=Data.SensAccAxial(m,1);
        Traj(m,28)=Data.SensAccNormal(m,1);
        Traj(m,29)=Data.RollAngleECI(m,1);
        Traj(m,30)=Data.PitchAngleECI(m,1);
        Traj(m,31)=Data.YawAngleECI(m,1);
        Traj(m,32)=Data.RollAngleENU(m,1);
        Traj(m,33)=Data.PitchAngleENU(m,1);
        Traj(m,34)=Data.YawAngleENU(m,1);
        Traj(m,35)=Data.BodyRateAxial(m,1);
        Traj(m,36)=Data.BodyRateY(m,1);
        Traj(m,37)=Data.BodyRateZ(m,1);
        Traj(m,38)=Data.BallisticCoeff(m,1);
        Traj(m,39)=Data.Mass(m,1);
        Traj(m,40)=Data.CPPitchPlane(m,1);
        Traj(m,41)=Data.CPYawPlane(m,1);
        Traj(m,42)=Data.Airspeed(m,1);
        Traj(m,43)=Data.Ixx(m,1);
        Traj(m,44)=Data.Iyy(m,1);
        Traj(m,45)=Data.Izz(m,1);
        Traj(m,46)=Data.TimeOfLiftoff(m,1);
        Traj(m,47)=Data.MachNumber(m,1);
        Traj(m,48)=Data.SensedAccelY(m,1);
        Traj(m,49)=Data.SensedAccelZ(m,1);
        Traj(m,50)=Data.DynamicPress(m,1);
        Traj(m,51)=Data.PitchAoA(m,1);
        Traj(m,52)=Data.YawAoA(m,1);
        Traj(m,53)=Data.TimeLastState(m,1);
        Traj(m,54)=Data.TargetLat(m,1);
        Traj(m,55)=Data.TargetLong(m,1);
        Traj(m,56)=Data.DragCoeff(m,1);
        Traj(m,57)=Data.CMalphaSlope(m,1);
        Traj(m,58)=Data.TALO(m,1);
    end
% Now store this in the proper place in the results array
    for jj=1:58
        Results{1+n,jj}=Traj(:,jj);
    end
    Results{1+n,59}=shortfilename;
% Check to see if this file is in ECI coordinates
% Flag1=0 can not determine
% Flag1=1 ECI coordinates
% Flag1=2 ECR coordinates
    Flag1=0;
    if((Traj(1,1)<10.0) && (Traj(1,42)>50))
        Flag1=1;
    elseif((Traj(1,1)<10.0) && (Traj(1,42)<=50))
        Flag1=2;
    end
    Results{1+n,60}=Flag1;
end
% Now compare key quantities from the two files
% Start with the Yaw angle from the ECI
Time1=Results{2,1};
Time2=Results{3,1};
Yaw1=Results{2,31};
Yaw2=Results{3,31};
YawECR=Yaw2;
YawECI=Yaw1;
iselect=3;
titlestr='Yaw Angle Comparison';
figstr='YawAngleComparison.jpg';
PlotSelectedEulerAngle(Time1,Time2,Yaw1,Yaw2,iselect,...
    classification,titlestr,figstr)
% Continue with the Roll Angle from the ECI
Time1=Results{2,1};
Time2=Results{3,1};
Roll1=Results{2,29};
Roll2=Results{3,29};
iselect=1;
titlestr='Roll Angle Comparison';
figstr='RollAngleComparison.jpg';
PlotSelectedEulerAngle(Time1,Time2,Roll1,Roll2,iselect,...
    classification,titlestr,figstr)
% Continue with the Pitch Angle from the ECI
Time1=Results{2,1};
Time2=Results{3,1};
Pitch1=Results{2,30};
Pitch2=Results{3,30};
iselect=2;
titlestr='Pitch Angle Comparison';
figstr='PitchAngleComparison.jpg';
PlotSelectedEulerAngle(Time1,Time2,Pitch1,Pitch2,iselect,...
    classification,titlestr,figstr)
% Now come up with a corrected ECI Yaw value from the ECR value of the Yaw
numpts=length(Time1);
YawECICalc=zeros(numpts,1);
for m=1:numpts
    YawECICalc(m,1)=YawECR(m,1)+0.004178*Time1(m,1);
end
iselect=4;
titlestr='Corrected Yaw Angle Comparison';
figstr='CorrectedYawAngleComparison.jpg';
PlotSelectedEulerAngle(Time1,Time2,YawECI,YawECICalc,iselect,...
    classification,titlestr,figstr)
% Continue with VMag
Time1=Results{2,1};
Time2=Results{3,1};
VMag1=Results{2,42};
VMag2=Results{3,42};
titlestr='VMag Comparison';
figstr='VMagComparison.jpg';
PlotVMag(Time1,Time2,VMag1,VMag2,classification,titlestr,figstr)
% Now correct the ECEF file data to ECI
% build and ecef vector in the format [x xdot xdot2 y ydot ydot2...]
ecef=zeros(9,numpts);
ecef(1,:)=Results{3,9};
ecef(2,:)=Results{3,15};
ecef(3,:)=Results{3,21};
ecef(4,:)=Results{3,10};
ecef(5,:)=Results{3,16};
ecef(6,:)=Results{3,22};
ecef(7,:)=Results{3,11};
ecef(8,:)=Results{3,17};
ecef(9,:)=Results{3,23};
eci = ecef2eci(ecef,Time1);
CorrECIx(:,1)=eci(1,:);
CorrECIvx(:,1)=eci(2,:);
CorrECIax(:,1)=eci(3,:);
CorrECIy(:,1)=eci(4,:);
CorrECIvy(:,1)=eci(5,:);
CorrECIay(:,1)=eci(6,:);
CorrECIz(:,1)=eci(7,:);
CorrECIvz(:,1)=eci(8,:);
CorrECIaz(:,1)=eci(9,:);
VMagCorr=zeros(numpts,1);
ECIAccelX=Results{2,21};
ECIAccelY=Results{2,22};
ECIAccelZ=Results{2,23};
AMagECI=zeros(numpts,1);
AMagCorr=zeros(numpts,1);
for m=1:numpts
    vxnow=CorrECIvx(m,1);
    vynow=CorrECIvy(m,1);
    vznow=CorrECIvz(m,1);
    VMagCorr(m,1)=sqrt(vxnow^2 + vynow^2 + vznow^2);
    axnow=ECIAccelX(m,1);
    aynow=ECIAccelY(m,1);
    aznow=ECIAccelZ(m,1);
    AMagECI(m,1)=sqrt(axnow^2 + aynow^2 + aznow^2);
    axcorrnow=CorrECIax(m,1);
    aycorrnow=CorrECIay(m,1);
    azcorrnow=CorrECIaz(m,1);
    AMagCorr(m,1)=sqrt(axcorrnow^2 +aycorrnow^2 + azcorrnow^2);
end
titlestr='VMag Correction Comparison';
figstr='VMagCorrectionComparison.jpg';
PlotVMag(Time1,Time2,VMag1,VMagCorr,classification,titlestr,figstr)
% Now compare the acceleartion magnitude
titlestr='AccelMag Correction Comparison';
figstr='AccelMagCorrectionComparison.jpg';
PlotAccelMag(Time1,Time2,AMagECI,AMagCorr,...
    classification,titlestr,figstr)
% Check out the ENU coordinates
ENU1X=Results{2,13};
ENU1Y=Results{2,14};
ENU1Z=Results{2,15};
ENU2X=Results{3,13};
ENU2Y=Results{3,14};
ENU2Z=Results{3,15};
iselect=1;
titlestr='ENU X Component Comparison';
figstr='ENUXComparison.jpg';
PlotSelectedENUCoord(Time1,Time2,ENU1X,ENU2X,iselect,...
    classification,titlestr,figstr)
elapsed_time=toc;
dispstr=strcat('Run took-',num2str(elapsed_time,5),'-sec');
disp(dispstr)