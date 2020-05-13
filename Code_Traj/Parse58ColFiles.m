% This script will split 58 col files that have multiple objects into
% single object asc files.
% 
% Written By: Stephen Forczyk
% Created: Nov 3,2014
% Revised: Nov 4,2014 to deal with destination folder location problems
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
icase=6;

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
    sourcedir='E:\Forczyk\Trajectories\Data3\L128cD03P35_IR1_Barrow_all_objects_ECR\';
    destdir='E:\Forczyk\Trajectories\Data3\L128cD03P35_IR1_Barrow_all_Parsed\';
    jpegpath='E:\Forczyk\Trajectories\Data3\L128cD03P35_IR1_Barrow_all\Jpeg\';
    excelpath='E:\Forczyk\Trajectories\Data3\L128cD03P35_IR1_Barrow_all\Excel_Files\';
    [FileList] = getfilelist(sourcedir,'.asc','True');
    numfiles=length(FileList);
    ExcelFileName='L128cD03P35_IR1_Barrow_All_Obj_ECR.xls';
    TabName='L128aD03P35';
    ab=3;
elseif(icase==4)
    sourcedir='D:\Forczyk\MS2_Check\Trajectory1\Source_Directory\';
    destdir='D:\Forczyk\MS2_Check\Trajectory1\Parsed_Traj_Files\';
    jpegpath='D:\Forczyk\MS2_Check\Trajectory1\Jpeg\';
    excelpath='D:\Forczyk\MS2_Check\Trajectory1\Excel_Files\';
    [FileList] = getfilelist(sourcedir,'.asc','True');
    numfiles=length(FileList);
    ExcelFileName='DingoskiTraj.xls';
    TabName='Dingoski';
    
    ab=3;
elseif(icase==6)
    sourcedir='D:\Forczyk\MS2_Check\Trajectory3\Source_Directory\';
    destdir='D:\Forczyk\MS2_Check\Trajectory3\Parsed_Traj_Files\';
    jpegpath='D:\Forczyk\MS2_Check\Trajectory3\Jpeg\';
    excelpath='D:\Forczyk\MS2_Check\Trajectory3\Excel_Files\';
    [FileList] = getfilelist(sourcedir,'.asc','True');
    numfiles=length(FileList);
    ExcelFileName='DingoskiTraj.xls';
    TabName='Dingoski';
    
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
    dispstr=strcat('Now processing merged file-',shortfilename);
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