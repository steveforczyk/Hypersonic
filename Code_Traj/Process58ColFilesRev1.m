% This script will split 58 col files that have multiple objects into
% single object asc files.
% 
% Written By: Stephen Forczyk
% Created: Nov 3,2014
% Revised: Nov 4,2014 toi deal with destination folder location problems
%          and repeated object names in original file issue

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

global topdir destdir jpegpath excelpath sourcedir;
global ipowerpoint PowerPointFile scaling stretching padding;
global statistics_toolbox signal_toolbox;
global ichartnum;

clc

loadedfiles=0;
ipowerpoint=0;
ijpeg=1;
icase=3;

if(icase==1)
    topdir='E:\Forczyk\Trajectories\Data\';
    jpegpath='E:\Forczyk\Trajectories\Jpeg\';
    [FileList] = getfilelist(topdir,'.asc','True');
    numfiles=length(FileList);
elseif(icase==2)
    topdir='E:\Forczyk\Trajectories\Data2\';
    jpegpath='E:\AAT\Forczyk\Trajectories\Jpeg2\';
    [FileList] = getfilelist(topdir,'.asc','True');
    numfiles=length(FileList);
elseif(icase==3)
    sourcedir='E:\Forczyk\Trajectories\Data3\L128cD03P35_IR1_Barrow_all_Parsed\';
    destdir='E:\Forczyk\Trajectories\Data3\L128cD03P35_IR1_Barrow_all_Parsed_ECI\';
    jpegpath='E:\Forczyk\Trajectories\Data3\L128cD03P35_IR1_Barrow_ECR\Jpeg\';
    excelpath='E:\Forczyk\Trajectories\Data3\L128cD03P35_IR1_Barrow_all_Parsed_ECI\Excel_Files\';
    [FileList] = getfilelist(sourcedir,'.asc','True');
    numfiles=length(FileList);
    ExcelFileName='L128cD03P35_IR1_Barrow_All_Obj_ECR.xls';
    TabName='L128aD03P35';
    ab=3;
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
dispstr=strcat('Found-',num2str(numfiles,4),'-Files that may need to be split and or converted');
disp(dispstr);
Results=cell(1,1);
Results{1,1}='Parent File';
Results{1,2}='NumObjects';
Results{1,3}='Header Lines';
Results{1,4}='Current Object';
Results{1,5}='Single File Name';
Results{1,6}='ECIFlag';
% Delete a preexisting version of the Excel Results file if it already
% exists
eval(['cd ' excelpath(1:length(excelpath)-1)]);
a1=exist(ExcelFileName,'file');
if(a1==2)
    delete(ExcelFileName);
    dispstr=strcat('Older copy of Excel File-',ExcelFileName,...
        '-deleted before opening new file');
    disp(dispstr);
end

% Go through these files one at a time
% First find the unique folder names
FolderNames=cell(numfiles,1);
for n=1:numfiles
    filename=FileList{n,1};
    [islash]=strfind(filename,'\');
    numslash=length(islash);
    is=1;
    ie=islash(numslash);
    foldername=filename(is:ie);
    FolderNames{n,1}=foldername;
end
UniqueFolderNames=unique(FolderNames);
numunique=length(UniqueFolderNames);
FolderInfo=cell(numunique,5);
for n=1:numunique
    foldername=UniqueFolderNames{n,1};
    FolderInfo{n,1}=foldername;
    eval(['cd ' foldername(1:length(foldername)-1)]);
% now get a listing of this directory
   dirlis=dir;
   numindir=length(dirlis)-2;
   ab=1;
% If files are found search through the list for critical path files
   if(numindir>0)
       for m=3:numindir+2
          dirfilename=dirlis(m).name;
          a1=strfind(dirfilename,'criticalpath');
          a2=length(a1);
          if(a2>0);
              FolderInfo{n,2}=dirfilename;
              FolderInfo{n,3}=0;
              FolderInfo{n,4}=0;
              FolderInfo{n,5}=0;
% Before attempting to import the file establish how many header records
% are present
%              fid=fopen(dirfilename,'r');
% keep reading this file until a line with periods is encountered-this is
% the first data record
%              nheaders=0;
%               idatafound=0;
%               while (idatafound<1)
%                     tline=fgetl(fid);
%                     [iper]=strfind(tline,'.');
%                     numper=length(iper);
%                     if(numper<2)
%                         nheaders=nheaders+1;
%                         idatafound=0;
%                     else
%                         idatafound=1;
%                     end
%               end
%               fclose(fid);
% Now import this file
              [Data,nheaders]=LoadBMRD58Rev4(dirfilename);
              numvals=length(Data.Time);
              Traj=zeros(numvals,58);
              for k=1:numvals
                    Traj(k,1)=Data.Time(k,1);
                    Traj(k,2)=Data.GroundRange(k,1);
                    Traj(k,3)=Data.Altitude(k,1);
                    Traj(k,4)=Data.AngleofAttack(k,1);
                    Traj(k,5)=Data.FlightPathAng(k,1);
                    Traj(k,6)=Data.PrecessionCone(k,1);
                    Traj(k,7)=Data.Thrust(k,1);
                    Traj(k,8)=Data.CGAxial(k,1);
                    Traj(k,9)=Data.PositionECIx(k,1);
                    Traj(k,10)=Data.PositionECIy(k,1);
                    Traj(k,11)=Data.PositionECIz(k,1);
                    Traj(k,12)=Data.PositionENUx(k,1);
                    Traj(k,13)=Data.PositionENUy(k,1);
                    Traj(k,14)=Data.PositionENUz(k,1);
                    Traj(k,15)=Data.VelocityECIx(k,1);
                    Traj(k,16)=Data.VelocityECIy(k,1);
                    Traj(k,17)=Data.VelocityECIz(k,1);
                    Traj(k,18)=Data.VelocityENUx(k,1);
                    Traj(k,19)=Data.VelocityENUy(k,1);
                    Traj(k,20)=Data.VelocityENUz(k,1);
                    Traj(k,21)=Data.AccelECIx(k,1);
                    Traj(k,22)=Data.AccelECIy(k,1);
                    Traj(k,23)=Data.AccelECIz(k,1);
                    Traj(k,24)=Data.AccelENUx(k,1);
                    Traj(k,25)=Data.AccelENUy(k,1);
                    Traj(k,26)=Data.AccelENUz(k,1);
                    Traj(k,27)=Data.SensAccAxial(k,1);
                    Traj(k,28)=Data.SensAccNormal(k,1);
                    Traj(k,29)=Data.RollAngleECI(k,1);
                    Traj(k,30)=Data.PitchAngleECI(k,1);
                    Traj(k,31)=Data.YawAngleECI(k,1);
                    Traj(k,32)=Data.RollAngleENU(k,1);
                    Traj(k,33)=Data.PitchAngleENU(k,1);
                    Traj(k,34)=Data.YawAngleENU(k,1);
                    Traj(k,35)=Data.BodyRateAxial(k,1);
                    Traj(k,36)=Data.BodyRateY(k,1);
                    Traj(k,37)=Data.BodyRateZ(k,1);
                    Traj(k,38)=Data.BallisticCoeff(k,1);
                    Traj(k,39)=Data.Mass(k,1);
                    Traj(k,40)=Data.CPPitchPlane(k,1);
                    Traj(k,41)=Data.CPYawPlane(k,1);
                    Traj(k,42)=Data.Airspeed(k,1);
                    Traj(k,43)=Data.Ixx(k,1);
                    Traj(k,44)=Data.Iyy(k,1);
                    Traj(k,45)=Data.Izz(k,1);
                    Traj(k,46)=Data.TimeOfLiftoff(k,1);
                    Traj(k,47)=Data.MachNumber(k,1);
                    Traj(k,48)=Data.SensedAccelY(k,1);
                    Traj(k,49)=Data.SensedAccelZ(k,1);
                    Traj(k,50)=Data.DynamicPress(k,1);
                    Traj(k,51)=Data.PitchAoA(k,1);
                    Traj(k,52)=Data.YawAoA(k,1);
                    Traj(k,53)=Data.TimeLastState(k,1);
                    Traj(k,54)=Data.TargetLat(k,1);
                    Traj(k,55)=Data.TargetLong(k,1);
                    Traj(k,56)=Data.DragCoeff(k,1);
                    Traj(k,57)=Data.CMalphaSlope(k,1);
                    Traj(k,58)=Data.TALO(k,1);
              end
            ab=1;
% Check to see if this file is in ECI coordinates
% Flag1= ECI flag 0=No,1=Yes
% Flag2= ECR flag 0=No,1=Yes

            Flag1=0;
            Flag2=0;
            if((Traj(1,1)<10.0) && (Traj(1,42)>50))
                Flag1=1;
                Flag2=0;
            elseif((Traj(1,1)<10.0) && (Traj(1,42)<=50))
                Flag1=0;
                Flag2=1;
            end
            FolderInfo{n,3}=Flag1;
            FolderInfo{n,4}=Flag2;
            FolderInfo{n,5}=nheaders;
          end
       end
% else no files were found
   else
       ab=2;
   end
end
% Create an array called NewFolderInfo which has the same names
% as FolderInfo except NewFolderInfo{:,1} will contain the directory
% name the corrected ECI files will be stored in
NewFolderInfo=FolderInfo;
for n=1:numunique
    oldir=FolderInfo{n,1};
    [islash]=strfind(oldir,'\');
    numslash=length(islash);
    is=1;
    ie=islash(numslash-1)-1;
    dirstub=oldir(is:ie);
    newdirstub=strcat(dirstub,'_ECI');
    is=ie+1;
    ie=islash(numslash);
    suffix=oldir(is:ie);
    newdir=strcat(newdirstub,suffix);
    NewFolderInfo{n,1}=newdir;
end
ifailedcopy=0;
icopied=0;
iconverted=0;
% Go through the file list one more time to assign the Folder properties
for n=1:numfiles
    filename=FileList{n,1};
    [islash]=strfind(filename,'\');
    numslash=length(islash);
    filelen=length(filename);
    is=1;
    ie=islash(numslash);
    foldername=filename(is:ie);
% See which of the unique folders this matches
   for jj=1:numunique
       uniquefoldername=FolderInfo{jj,1};
       a1=strcmp(foldername,uniquefoldername);
       a2=length(a1);
       if(a1>0)
           FileList{n,2}=jj;
           FileList{n,3}=FolderInfo{jj,3};
           FileList{n,4}=FolderInfo{jj,4};
           FileList{n,5}=FolderInfo{jj,5};
       end
   end
end
ab=1;
% Now process each of these files using the knowledge gained earlier
nentries=0;
for n=1:numfiles
    ab=7;
    filename=FileList{n,1};
    [islash]=strfind(filename,'\');
    numslash=length(islash);
    filelen=length(filename);
    is=islash(numslash)+1;
    ie=filelen;
    shortfilename=filename(is:ie);
    dispstr=strcat('Now processing split file-',shortfilename,'-File-',num2str(n,4),...
        '-of-',num2str(numfiles,5));
    disp(dispstr);
    [iper]=strfind(shortfilename,'.');
    is=1;
    ie=iper(1)-4;
    prefix=shortfilename(is:ie);
    ecifilename=strcat(prefix,'ECI.asc');
    ECIFlag=FileList{n,3};
    [iper]=strfind(filename,'.');
    is=1;
    ie=iper(1)-1;
%   destdir2=strcat(filename(is:ie),'\Parsed');
%    destdir2=strcat(destdir,prefix,'\');
%    destfilename=strcat(destdir,ecifilename);
    fileindex=FileList{n,2};
    newdestdir=NewFolderInfo{fileindex,1};
    destfilename=strcat(newdestdir,ecifilename);
    ab=3;
% see if this destination directory already exists-if not create it
    a5=exist(newdestdir,'dir');
    if(a5~=7)
        [status]=mkdir(newdestdir);
        if(status==1)
            dispstr=strcat('Created directory-',newdestdir);
        else
            dispstr=strcat('Failed to create directory-',newdestdir);
        end
        disp(dispstr)
    end
% if the file is already in ECI change the name and write as is
% if not perform the needed changes then write
    if(ECIFlag==1)
        status=copyfile(filename,destfilename);
        if(status==0)
            ifailedcopy=ifailedcopy+1;
        else
            icopied=icopied+1;
        end
    elseif(ECIFlag==0)
% Now read the file in order to convert it
        [Data,nheaders,HeaderRecords]=LoadBMRD58Rev4(filename);
        numvals=length(Data.Time);
        Traj=zeros(numvals,58);
        for k=1:numvals
            Traj(k,1)=Data.Time(k,1);
            Traj(k,2)=Data.GroundRange(k,1);
            Traj(k,3)=Data.Altitude(k,1);
            Traj(k,4)=Data.AngleofAttack(k,1);
            Traj(k,5)=Data.FlightPathAng(k,1);
            Traj(k,6)=Data.PrecessionCone(k,1);
            Traj(k,7)=Data.Thrust(k,1);
            Traj(k,8)=Data.CGAxial(k,1);
            Traj(k,9)=Data.PositionECIx(k,1);
            Traj(k,10)=Data.PositionECIy(k,1);
            Traj(k,11)=Data.PositionECIz(k,1);
            Traj(k,12)=Data.PositionENUx(k,1);
            Traj(k,13)=Data.PositionENUy(k,1);
            Traj(k,14)=Data.PositionENUz(k,1);
            Traj(k,15)=Data.VelocityECIx(k,1);
            Traj(k,16)=Data.VelocityECIy(k,1);
            Traj(k,17)=Data.VelocityECIz(k,1);
            Traj(k,18)=Data.VelocityENUx(k,1);
            Traj(k,19)=Data.VelocityENUy(k,1);
            Traj(k,20)=Data.VelocityENUz(k,1);
            Traj(k,21)=Data.AccelECIx(k,1);
            Traj(k,22)=Data.AccelECIy(k,1);
            Traj(k,23)=Data.AccelECIz(k,1);
            Traj(k,24)=Data.AccelENUx(k,1);
            Traj(k,25)=Data.AccelENUy(k,1);
            Traj(k,26)=Data.AccelENUz(k,1);
            Traj(k,27)=Data.SensAccAxial(k,1);
            Traj(k,28)=Data.SensAccNormal(k,1);
            Traj(k,29)=Data.RollAngleECI(k,1);
            Traj(k,30)=Data.PitchAngleECI(k,1);
            Traj(k,31)=Data.YawAngleECI(k,1);
            Traj(k,32)=Data.RollAngleENU(k,1);
            Traj(k,33)=Data.PitchAngleENU(k,1);
            Traj(k,34)=Data.YawAngleENU(k,1);
            Traj(k,35)=Data.BodyRateAxial(k,1);
            Traj(k,36)=Data.BodyRateY(k,1);
            Traj(k,37)=Data.BodyRateZ(k,1);
            Traj(k,38)=Data.BallisticCoeff(k,1);
            Traj(k,39)=Data.Mass(k,1);
            Traj(k,40)=Data.CPPitchPlane(k,1);
            Traj(k,41)=Data.CPYawPlane(k,1);
            Traj(k,42)=Data.Airspeed(k,1);
            Traj(k,43)=Data.Ixx(k,1);
            Traj(k,44)=Data.Iyy(k,1);
            Traj(k,45)=Data.Izz(k,1);
            Traj(k,46)=Data.TimeOfLiftoff(k,1);
            Traj(k,47)=Data.MachNumber(k,1);
            Traj(k,48)=Data.SensedAccelY(k,1);
            Traj(k,49)=Data.SensedAccelZ(k,1);
            Traj(k,50)=Data.DynamicPress(k,1);
            Traj(k,51)=Data.PitchAoA(k,1);
            Traj(k,52)=Data.YawAoA(k,1);
            Traj(k,53)=Data.TimeLastState(k,1);
            Traj(k,54)=Data.TargetLat(k,1);
            Traj(k,55)=Data.TargetLong(k,1);
            Traj(k,56)=Data.DragCoeff(k,1);
            Traj(k,57)=Data.CMalphaSlope(k,1);
            Traj(k,58)=Data.TALO(k,1);
        end
% Now correct the ECEF file data to ECI
% build and ecef vector in the format [x xdot xdot2 y ydot ydot2...]
        ecef=zeros(9,numvals);
        ecef(1,:)=Traj(:,9);
        ecef(2,:)=Traj(:,15);
        ecef(3,:)=Traj(:,21);
        ecef(4,:)=Traj(:,10);
        ecef(5,:)=Traj(:,16);
        ecef(6,:)=Traj(:,22);
        ecef(7,:)=Traj(:,11);
        ecef(8,:)=Traj(:,17);
        ecef(9,:)=Traj(:,23);
        Time1=Traj(:,1);
        eci = ecef2eci(ecef,Time1);
        clear CorrECIx CorrECIvx CorrECIax
        clear CorrECIy CorrECIvy CorrECIay
        clear CorrECIz CorrECIvz CorrECIaz
        CorrECIx(:,1)=eci(1,:);
        CorrECIvx(:,1)=eci(2,:);
        CorrECIax(:,1)=eci(3,:);
        CorrECIy(:,1)=eci(4,:);
        CorrECIvy(:,1)=eci(5,:);
        CorrECIay(:,1)=eci(6,:);
        CorrECIz(:,1)=eci(7,:);
        CorrECIvz(:,1)=eci(8,:);
        CorrECIaz(:,1)=eci(9,:);
        VMagCorr=zeros(numvals,1);
        ECIAccelX=Traj(:,21);
        ECIAccelY=Traj(:,22);
        ECIAccelZ=Traj(:,23);
        AMagECI=zeros(numvals,1);
        AMagCorr=zeros(numvals,1);
        for m=1:numvals
            vxnow=CorrECIvx(m,1);
            vynow=CorrECIvy(m,1);
            vznow=CorrECIvz(m,1);
            VMagCorr(m,1)=sqrt(vxnow^2 + vynow^2 + vznow^2);
            axnow=CorrECIax(m,1);
            aynow=CorrECIay(m,1);
            aznow=CorrECIaz(m,1);
            AMagECI(m,1)=sqrt(axnow^2 + aynow^2 + aznow^2);

        end
% Correct the Yaw Euler Angle
        YawECICalc=zeros(numvals,1);
        YawECR=Traj(:,31);
        for m=1:numvals
            YawECICalc(m,1)=YawECR(m,1)+0.004178*Time1(m,1);
        end
% Now substitute the new values in the Traj Array
        Traj(:,9)=CorrECIx(:,1);
        Traj(:,10)=CorrECIy(:,1);
        Traj(:,11)=CorrECIz(:,1);
        Traj(:,15)=CorrECIvx(:,1);
        Traj(:,16)=CorrECIvy(:,1);
        Traj(:,17)=CorrECIvz(:,1);
        Traj(:,21)=CorrECIax(:,1);
        Traj(:,22)=CorrECIay(:,1);
        Traj(:,23)=CorrECIaz(:,1);
        Traj(:,31)=YawECICalc(:,1);
        Traj(:,42)=VMagCorr(:,1);
% Now write this file out-start with the header records
        ab=6;
        fid2=fopen(destfilename,'w');
        for mm=1:nheaders
            tline=HeaderRecords(mm,:);
            tline2=deblank(tline);
            fprintf(fid2,'%s \n',tline2);
        end
        space=' ';
        space2='__';
        for mm=1:numvals
            fprintf(fid2,'%15.6f  %15.6f  %13.5f',Traj(mm,1),Traj(mm,2),Traj(mm,3));
            fprintf(fid2,' %13.3f %13.3f  %12.3f',Traj(mm,4),Traj(mm,5),Traj(mm,6));
            fprintf(fid2,'%15.4f %13.3f  %15.6f',Traj(mm,7),Traj(mm,8),Traj(mm,9));
            fprintf(fid2,'  %15.6f %15.6f  % 15.6f',Traj(mm,10),Traj(mm,11),Traj(mm,12));
            fprintf(fid2,'   %15.6f  %15.6f  % 15.6f',Traj(mm,13),Traj(mm,14),Traj(mm,15));
            fprintf(fid2,'   %15.6f  %15.6f  % 15.6f',Traj(mm,16),Traj(mm,17),Traj(mm,18));
            fprintf(fid2,'  %15.6f  %15.6f  % 15.6f',Traj(mm,19),Traj(mm,20),Traj(mm,21));
            fprintf(fid2,'  %15.6f  %15.6f  % 15.6f',Traj(mm,22),Traj(mm,23),Traj(mm,24));
            fprintf(fid2,'  %15.6f  %15.6f  % 15.6f',Traj(mm,25),Traj(mm,26),Traj(mm,27));
            fprintf(fid2,'  %15.6f  %15.6f  % 15.6f',Traj(mm,28),Traj(mm,29),Traj(mm,30));
            fprintf(fid2,'  %15.6f  %15.6f  % 15.6f',Traj(mm,31),Traj(mm,32),Traj(mm,33));
            fprintf(fid2,'  %15.6f  %15.6f  % 15.6f',Traj(mm,34),Traj(mm,35),Traj(mm,36));
            fprintf(fid2,'  %15.6f  %12.3f   % 15.6f',Traj(mm,37),Traj(mm,38),Traj(mm,39));
            fprintf(fid2,'  %10.3f  %10.3f  % 15.6f',Traj(mm,40),Traj(mm,41),Traj(mm,42));
            fprintf(fid2,'  %18.6f  %18.6f  % 18.6f',Traj(mm,43),Traj(mm,44),Traj(mm,45));
            fprintf(fid2,'  %15.6f  %10.2f   % 15.6f',Traj(mm,46),Traj(mm,47),Traj(mm,48));
            fprintf(fid2,'  %15.6f  %13.4f   % 11.3f',Traj(mm,49),Traj(mm,50),Traj(mm,51));
            fprintf(fid2,'  %12.3f  %15.6f   % 14.6f',Traj(mm,52),Traj(mm,53),Traj(mm,54));
            fprintf(fid2,'  %15.6f  %13.4f   % 10.2f',Traj(mm,55),Traj(mm,56),Traj(mm,57));
            fprintf(fid2,'  %15.6f',Traj(mm,58));
            fprintf(fid2,'\n');
        end
        fclose(fid2);
        iconverted=iconverted+1;
        dispstr=strcat('//////Wrote file-',destfilename);
        disp(dispstr)
    end
    ab=7;
end
% Now write the data to an Excel File
eval(['cd ' excelpath(1:length(excelpath)-1)]);
[success]=xlswrite(ExcelFileName,Results,TabName,'a1');
dispstr=strcat('Wrote Feature Reports To File-',ExcelFileName);
disp(dispstr)
elapsed_time=toc;
dispstr=strcat('Run took-',num2str(elapsed_time,6),'-sec-total asc files processed=',num2str(numfiles,3),...
    '-new asc files created-',num2str(iconverted,5),'-num copied files=',num2str(icopied,5));
disp(dispstr)