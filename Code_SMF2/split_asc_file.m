%This m-file will examine 58-col files and split into multiple files if
%multiple datasets
%AUTHOR:    Chris Weekley
%DATE:      8/07/2013
%Updated:   Brooke Howe - 10/22/14 - Added threat name and scenario to rename files.
% Revised: Stephen Forczyk-renamed file and modified it to process one file
% at a time Feb 23,2019
clear;
% sourcedir = uigetdir('','Select Folder with ASCII 58 Column Trajectories');
% files = strcat(sourcedir,'\*.asc');
% dirList = dir(files);
% num = 1;
% threat = 'L167aD04P01v2';
% scenario = 's08';
% outdir =
% fullfile('K:\Threats\Delivered_Data\',threat,scenario,'Trajectory\58col');
cd H:\MDSET\Trajectories\SMHR_to_58Col
[file,path,indx] = uigetfile('*.*','Select a 58 col file');
filename=strcat(path,file);
% read file and split
ab=1;
for i = 1:1
%    fid = fopen(fullfile(sourcedir,dirList(i).name),'r'); 
    fid = fopen(filename,'r'); 
%     if strcmp(dirList(i).name,dirList(9).name)
%        disp('pause');
%     end
    if fid == -1
        error('file: %s - does not exist', dirList(i).name) ;
    end
%    filename = strrep(dirList(i).name,'.asc','');
    strlength = length(filename);
%     runnum = filename(end-2:end);
%     outdirrun = fullfile(outdir,runnum);
%     if ~exist(outdirrun)
%         mkdir(outdirrun)
%     end
    %% read data
    line1 = fgetl(fid);
    vdata = strread(line1, '%s');
    numds = str2num(vdata{1});
    dsnamesv = 'none';
    runnum=1;
    if numds > 1
        for m = 2:5
            linesv{m} = fgetl(fid);
        end
        vdata = strread(linesv{2}, '%s');
  %      fname = strrep(dirList(i).name,dirList(i).name,strcat(threat,'_',scenario,'_',runnum,'_',vdata{2},'.asc'));
        fname = strrep(filename,strcat(threat,'_',scenario,'_',runnum,'_',vdata{2},'.asc'));
        ofid = fopen(fullfile(outdirrun,fname),'w+');  
        ofid = fopen(fname,'w+');  
        sline = strrep(line1,num2str(numds),'1');
        fprintf(ofid,'%s\n',sline);     
        for m = 2:5
            fprintf(ofid,'%s\n',linesv{m});     
        end
        dscnt = 1;
        % loop through datasets
        while ~feof(fid)         
            line = fgetl(fid);
            vdata = strread(line, '%s');
            while strcmp(vdata{1},'dataset:') == 0 && ~feof(fid)
                fprintf(ofid,'%s\n',line);     
                line = fgetl(fid);
                vdata = strread(line, '%s');
            end
            fclose(ofid);
            if feof(fid)
                break;
            end
            dsname = vdata{2};
            if strcmp(dsname,dsnamesv) == 1
                if dscnt == 1
                    fname1 = fullfile(outdirrun,strrep(dirList(i).name,dirList(i).name,strcat(threat,'_',scenario,'_',runnum,'_',dsname,'.asc')));
                    fname2 = fullfile(outdirrun,strrep(dirList(i).name,dirList(i).name,strcat(threat,'_',scenario,'_',runnum,'_',dsname,'1.asc')));
                    movefile(fname1,fname2);
                end
                dscnt = dscnt + 1;
                dsname = strcat(dsname,num2str(dscnt));
            else
                dscnt = 1;
            end
            dsname
            dsnamesv = vdata{2};
            fname = strrep(dirList(i).name,dirList(i).name,strcat(threat,'_',scenario,'_',runnum,'_',dsname,'.asc'));
            
            ofid = fopen(fullfile(outdirrun,fname),'w+');  
            sline = strrep(line1,num2str(numds),'1');
            fprintf(ofid,'%s\n',sline);     
            fprintf(ofid,'%s\n',line);     
        end
    end
 end

