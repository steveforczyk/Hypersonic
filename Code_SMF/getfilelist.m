function [ FileList ] = getfilelist( topDir, suffix, outputFlag )
%GETFILELIST generates a list of files with specified suffix under topDir.
%   This function lists files with specified suffix under topDir. It
%   searches all levels of subfolders.
%
%   FileList: a cell to store the list.
%   topDir: top directory in which files are searched.
%   suffix: type of files to search, default by AVI.
%   outputFlag: a bool value to determine whether an output file is
%   generated.
%
%   Shiquan Wang @ CASIA
%   sqwang@nlpr.ia.ac.cn/shiquanwang@gmail.com
%   http://www.cbsr.ia.ac.cn/users/sqwang/
%   revised on 2009/10/26

%% Initialize Parameters
if nargin < 3
    outputFlag =input('Enter the outputFlag[(true/false)true by default]:');
    if isempty(outputFlag)
        outputFlag = true;
    end
end
if nargin < 2
    suffix =input('Enter the suffix of files[AVI by default]:', 's');
    if isempty(suffix)
        suffix = 'avi';
    end
end
if nargin < 1
    topDir = input('Enter the top level dir that contains files:', 's');
end

%% Call sub-function INTOFOLDER to list all files under topDir
[ fileList, numFolderList ] = intofolder( topDir );

%% Store files with match suffix to FileList
FileList = cell(1, 1);
indexList = 0;
for i = 1:1:size(fileList)
    fileFullPath = fileList{i, 1};
    [ tempPath, checkLabel] = filecheck( fileFullPath, suffix ); %check file suffix
    if checkLabel == 0
        indexList = indexList + 1;
        FileList{indexList, 1} = tempPath;
    end
    dispTmp = sprintf('This is file No.%2d/n', i);
%    disp(dispTmp); % This can be turned off.
end

%% Output file if outputFlag is true
if outputFlag
    outputPath = fullfile(topDir, 'FileList.txt');
    outputMAT = fullfile(topDir, 'FileList.mat');
%     fidList = fopen(outputPath, 'w');
%     for i = 1:1:size(FileList, 1)
%         fprintf(fidList, '%s\n', FileList{i, 1});
%     end
%     fclose(fidList);
%     save(outputMAT, 'FileList');
end
end

%% This function call itself recursively
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Sub Fuction%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%[ fileList,numFolderList]=intofolder(topDir,numFolderList,fileList )%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ fileList, numFolderList ] = intofolder( topDir, numFolderList, fileList )
%INTOFOLDER Summary of this function goes here
%   Detailed explanation goes here

%% Initialize paprameters for first call
if nargin < 2
    numFolderList = 0;
    fileList = cell(1, 1);
end

%%
tempList = dir(topDir);
for i = 1:1:size(tempList, 1)
    if (~strcmp(tempList(i, 1).name, '.'))&&(~strcmp(tempList(i, 1).name, '..'))
        if tempList(i, 1).isdir == 1;
            tempTopDir = fullfile(topDir, tempList(i, 1).name);
            [ fileList, numFolderList ] = intofolder( tempTopDir, numFolderList, fileList );
        else
            numFolderList = numFolderList + 1;
            fileList{numFolderList, 1} = fullfile(topDir, tempList(i, 1).name);
        end
    end
end

end

%% This function checks suffix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Sub Fuction%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%[ fileFullPath, checkLabel] = filecheck( fileFullPath, suffix )%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ fileFullPath, checkLabel] = filecheck( fileFullPath, suffix )
%VIDEOCHECK Summary of this function goes here
%   Detailed explanation goes here

%% Initialize paprameter
checkLabel = 0;

%% Check suffix
nameCount = size(fileFullPath, 2);
if ~strcmp(fileFullPath(nameCount - size(suffix, 2) + 1 : nameCount), suffix)
    checkLabel = 1;
end
end

