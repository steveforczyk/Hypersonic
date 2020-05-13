function ImportOSCSumryTrajFile(filename)
% The purpose of this routine is to import trajectory data from a OSC
% generated SUMRYTRJ file
% Written By: Stephen Forczyk
% Created: May 4,2019

% Revised: -----
% Classification: Unclassified
% Column ID's
global SumaryTrajData iSumryTrajData;
SumaryTrajData=cell(1,1);
SumaryTrajData{1,1}='filename';
SumaryTrajData{1,2}='Time';
SumaryTrajData{1,3}='Alt-KM';
SumaryTrajData{1,4}='Lat';
SumaryTrajData{1,5}='Lon';
SumaryTrajData{1,6}='Vel-mps';
SumaryTrajData{1,7}='Path-Angle';
SumaryTrajData{1,8}='Course-Angle';
SumaryTrajData{1,9}='Range-km';
SumaryTrajData{1,10}='Elev';
SumaryTrajData{1,11}='Azim';
SumaryTrajData{1,12}='Attack-Angle';
SumaryTrajData{1,13}='Aspect Angle';
SumaryTrajData{1,14}='ROLLWND';
SumaryTrajData{1,15}='ROLLSEN';
SumaryTrajData{1,16}='ROLLNDR';
SumaryTrajData{1,17}='Ground-Range-km';
[test]=importdata(filename,' ',1);
data=test.data;
[nrows,ncols]=size(data);
TrajData=zeros(nrows,ncols);
for n=1:nrows
    for j=1:ncols
        TrajData(n,j)=data(n,j);
    end
end
SumaryTrajData{2,1}=filename;
for n=2:17
    SumaryTrajData{2,n}=TrajData(:,n-1);
end
Times(:,1)=TrajData(:,1);
numpts=length(Times);
first_time=Times(1,1);
last_time=Times(numpts,1);
ab=1;
outstr1=strcat('Imported Sumary Traj Data from file-',filename,'-which had-',...
    num2str(numpts),'-data points from t=',num2str(first_time),'-to-',...
    num2str(last_time),'-sec');
disp(outstr1);
iSumryTrajData=1;
end

