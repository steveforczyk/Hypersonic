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
% Now process each of these files
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
    dispstr=strcat('Now processing split file-',shortfilename);
    disp(dispstr);
    [iper]=strfind(shortfilename,'.');
    is=1;
    ie=iper(1)-1;
    prefix=shortfilename(is:ie);
    ECIFlag=1;
    [iper]=strfind(filename,'.');
    is=1;
    ie=iper(1)-1;
%   destdir2=strcat(filename(is:ie),'\Parsed');
    destdir2=strcat(destdir,prefix,'\');
    ab=3;
% see if this destination directory already exists-if not create it
    a5=exist(destdir2,'dir');
    if(a5~=7)
        [status]=mkdir(destdir2);
        if(status==1)
            dispstr=strcat('Created directory-',destdir2);
        else
            dispstr=strcat('Failed to create directory-',destdir2);
        end
        disp(dispstr)
    end
    ab=2;
    fid=fopen(filename,'r');
% The first line has the number of objects on this file
    tline = fgetl(fid);
    a1=strfind(tline,'total');
    a2=a1(1)-1;
    objstr=tline(1:a2);
    numobj=str2num(objstr);
    ab=1;
% Find out how many header lines exist
    nheader=0;
    nowobj=0;
    nowobjID='';
    nloc=1;
    newfiles=0;
    ObjectNames=cell(1,1);
    while ischar(tline)
        tline=fgetl(fid);
        a1=strfind(tline,'dataset:');
        b1=strfind(tline,'.');
        a2=length(a1);
        b2=length(b1);
        tlinelen=length(tline);
% if a1 is >0 then this line has the dataset id on it
        if((a2>0) && (newfiles==0))
            nowobj=nowobj+1;
            nloc=nloc+1;
            newfiles=newfiles+1;
            nentries=nentries+1;
            linelen=length(tline);
            a3=strfind(tline,':');
            is=a3+1;
            ie=linelen;
            nowObjID=tline(is:ie);
            nowObjID=strtrim(nowObjID);
% Rename some selected Object names
            a1=strcmp('critical_path',nowObjID);
            if(a1==1)
                nowObjID='criticalpath';
            end
            a1=strcmp('spent_1st_stage',nowObjID);
            if(a1==1)
                nowObjID='spentstage1';
            end
            a1=strcmp('spent_2nd_stage',nowObjID);
            if(a1==1)
                nowObjID='spentstage2';
            end
            a1=strcmp('spent_last_stage',nowObjID);
            if(a1==1)
                nowObjID='spentlaststage';
            end
            nowObjID=RemoveUnderScores(nowObjID);
            holdObjID=nowObjID;
            nheader=nheader+1;
            Results{nentries+1,1}=filename;
            Results{nentries+1,2}=numobj;
            Results{nentries+1,4}=nowObjID;
%            singlefilename=strcat(destdir2,'\',prefix,'_',nowObjID,'_UNK.asc');
            singlefilename=strcat(destdir2,prefix,'_',nowObjID,'_UNK.asc');
            Results{nentries+1,5}=singlefilename;
            ObjectNames{nowobj,1}=nowObjID;
            fid2=fopen(singlefilename,'w');
            fprintf(fid2,tline);
            fprintf(fid2,'\n');
            ab=2;
            ndata=0;
        elseif((a2>0) && (b2==0) && (newfiles>0))
            fclose(fid2);
            ab=3;
            [idash]=strfind(singlefilename,'\');
            numdash=length(idash);
            is=idash(numdash)+1;
            singlefilelen=length(singlefilename);
            ie=singlefilelen;
            shortsinglefilename=singlefilename(is:ie);
            dispstr=strcat('Wrote File-',shortsinglefilename,'-which is file-',num2str(newfiles,3),...
                '-of-',num2str(numobj,5),'-for this merged file');
            disp(dispstr)

            nloc=nloc+1;
            linelen=length(tline);
            a3=strfind(tline,':');
            is=a3+1;
            ie=linelen;
            nowObjID=tline(is:ie);
            nowObjID=strtrim(nowObjID);
% Rename a few specific files to insure 1 word names
            a1=strcmp('critical_path',nowObjID);
            if(a1==1)
                nowObjID='criticalpath';
            end
            a1=strcmp('spent_1st_stage',nowObjID);
            if(a1==1)
                nowObjID='spentstage1';
            end
            a1=strcmp('spent_2nd_stage',nowObjID);
            if(a1==1)
                nowObjID='spentstage2';
            end
            a1=strcmp('spent_last_stage',nowObjID);
            if(a1==1)
                nowObjID='spentlaststage';
            end
            ab=1;
            nowObjID=RemoveUnderScores(nowObjID);
            ab=4;
% some objects have duplicate names-see if the new proposed name is the
% same as an existing one. If so change it here
            numatch=0;
            matchobj=nowObjID;
            for mm=1:nowobj
                listobject=ObjectNames{mm,1};
                ab=1;
%                d1=strcmp(listobject,nowObjID);
                d1=strfind(listobject,nowObjID);
                d2=length(d1);
                if(d2>0)
                    numatch=numatch+1;
                    matchobj=listobject;
%                    nowObjID=strcat(nowObjID,'_',num2str(mm,2));
                end
            end
% Now build the object name taking into account duplicate names
            if(numatch>0)
                nowObjID=strcat(nowObjID,num2str(numatch,2));
            else
                nowObjID=nowObjID;
            end

            nowobj=nowobj+1;

            ObjectNames{nowobj,1}=nowObjID;
            nheader=1;
            newfiles=newfiles+1;
            nentries=nentries+1;
            Results{nentries+1,1}=filename;
            Results{nentries+1,2}=numobj;
            Results{nentries+1,4}=nowObjID;
%            singlefilename=strcat(destdir2,'\',prefix,'_',nowObjID,'_UNK.asc');
            singlefilename=strcat(destdir2,prefix,'_',nowObjID,'_UNK.asc');
            Results{nentries+1,5}=singlefilename;
            fid2=fopen(singlefilename,'w');
            ndata=0;
            fprintf(fid2,tline);
            fprintf(fid2,'\n');
            ab=2;
            
% if the next condition is true then this is just a header line
        elseif((a2<1) && (b2<1) && (tlinelen>1))
            nheader=nheader+1;
            fprintf(fid2,tline);
            fprintf(fid2,'\n');
% If the next condition is true this is a data line and write to the new file as is            
        elseif((b2>0) && (tlinelen>1))
            Results{newfiles+1,3}=nheader;
            fprintf(fid2,tline);
            fprintf(fid2,'\n');
            ndata=ndata+1;
% if this is the first data line find out if the data is in ECR or ECI
% format based on the value of the Vmag
            if(ndata==1)
% find out the time of the first point
               [iper]=strfind(tline,'.');
               numper=length(iper);
               is=iper(15)-5;
               ie=iper(15)+7;
               vxstr=tline(is:ie);
               vx=str2num(vxstr);
               is=iper(16)-5;
               ie=iper(16)+7;
               vystr=tline(is:ie);
               vy=str2num(vystr);
               is=iper(17)-5;
               ie=iper(17)+7;
               vzstr=tline(is:ie);
               vz=str2num(vzstr);
               vmag=sqrt(vx^2 + vy^2 + vz^2);
               is=iper(1)-5;
               ie=iper(1)+7;
               timestr=tline(is:ie);
               timenow=str2num(timestr);
               if((timenow<10) && (vmag<100))
                   ECIFlag=0;
               end
               Results{nentries+1,6}=ECIFlag;
            end
        elseif(tlinelen<2)
            fclose(fid2);
            ab=3;
            [idash]=strfind(singlefilename,'\');
            numdash=length(idash);
            is=idash(numdash)+1;
            singlefilelen=length(singlefilename);
            ie=singlefilelen;
            shortsinglefilename=singlefilename(is:ie);
            dispstr=strcat('Wrote File-',shortsinglefilename,'-which is file-',num2str(newfiles,3),...
                '-of-',num2str(numobj,5),'-for this merged file');
            disp(dispstr)

            nloc=nloc+1;

 
        end
    end
    ab=10;
end
% Now write the data to an Excel File
eval(['cd ' excelpath(1:length(excelpath)-1)]);
[success]=xlswrite(ExcelFileName,Results,TabName,'a1');
dispstr=strcat('Wrote Feature Reports To File-',ExcelFileName);
disp(dispstr)
elapsed_time=toc;
dispstr=strcat('Run took-',num2str(elapsed_time,6),'-sec-total asc files processed=',num2str(numfiles,3),...
    '-new asc files created-',num2str(nentries,4));
disp(dispstr)