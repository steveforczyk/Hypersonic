format long g

threat1 = csvread('threat001.csv');
[row col] = size(threat1);
fid = fopen('threat001_ecr.txt','w')
for i=1:row
state = threat1(i,2:10);
time = threat1(i,1);
state2 = eci2ecr_smhr(state,time);
threat1a(i,1) = time;
count = fprintf(fid,'%8.3f',threat1a(i,1));
threat1a(i,2:10) = state2;
for j=2:10
count = fprintf(fid,'\t%15.6f',threat1a(i,j));
end
count = fprintf(fid,'\n');
end
fclose(fid)

threat1 = csvread('threat002.csv');
[row col] = size(threat1);
fid = fopen('threat002_ecr.txt','w')
for i=1:row
state = threat1(i,2:10);
time = threat1(i,1);
state2 = eci2ecr_smhr(state,time);
threat1a(i,1) = time;
count = fprintf(fid,'%8.3f',threat1a(i,1));
threat1a(i,2:10) = state2;
for j=2:10
count = fprintf(fid,'\t%15.6f',threat1a(i,j));
end
count = fprintf(fid,'\n');
end
fclose(fid)

threat1 = csvread('threat003.csv');
[row col] = size(threat1);
fid = fopen('threat003_ecr.txt','w')
for i=1:row
state = threat1(i,2:10);
time = threat1(i,1);
state2 = eci2ecr_smhr(state,time);
threat1a(i,1) = time;
count = fprintf(fid,'%8.3f',threat1a(i,1));
threat1a(i,2:10) = state2;
for j=2:10
count = fprintf(fid,'\t%15.6f',threat1a(i,j));
end
count = fprintf(fid,'\n');
end
fclose(fid)

threat1 = csvread('threat004.csv');
[row col] = size(threat1);
fid = fopen('threat004_ecr.txt','w')
for i=1:row
state = threat1(i,2:10);
time = threat1(i,1);
state2 = eci2ecr_smhr(state,time);
threat1a(i,1) = time;
count = fprintf(fid,'%8.3f',threat1a(i,1));
threat1a(i,2:10) = state2;
for j=2:10
count = fprintf(fid,'\t%15.6f',threat1a(i,j));
end
count = fprintf(fid,'\n');
end
fclose(fid)

threat1 = csvread('threat005.csv');
[row col] = size(threat1);
fid = fopen('threat005_ecr.txt','w')
for i=1:row
state = threat1(i,2:10);
time = threat1(i,1);
state2 = eci2ecr_smhr(state,time);
threat1a(i,1) = time;
count = fprintf(fid,'%8.3f',threat1a(i,1));
threat1a(i,2:10) = state2;
for j=2:10
count = fprintf(fid,'\t%15.6f',threat1a(i,j));
end
count = fprintf(fid,'\n');
end
fclose(fid)

threat1 = csvread('threat006.csv');
[row col] = size(threat1);
fid = fopen('threat006_ecr.txt','w')
for i=1:row
state = threat1(i,2:10);
time = threat1(i,1);
state2 = eci2ecr_smhr(state,time);
threat1a(i,1) = time;
count = fprintf(fid,'%8.3f',threat1a(i,1));
threat1a(i,2:10) = state2;
for j=2:10
count = fprintf(fid,'\t%15.6f',threat1a(i,j));
end
count = fprintf(fid,'\n');
end
fclose(fid)

threat1 = csvread('threat007.csv');
[row col] = size(threat1);
fid = fopen('threat007_ecr.txt','w')
for i=1:row
state = threat1(i,2:10);
time = threat1(i,1);
state2 = eci2ecr_smhr(state,time);
threat1a(i,1) = time;
count = fprintf(fid,'%8.3f',threat1a(i,1));
threat1a(i,2:10) = state2;
for j=2:10
count = fprintf(fid,'\t%15.6f',threat1a(i,j));
end
count = fprintf(fid,'\n');
end
fclose(fid)

threat1 = csvread('threat008.csv');
[row col] = size(threat1);
fid = fopen('threat008_ecr.txt','w')
for i=1:row
state = threat1(i,2:10);
time = threat1(i,1);
state2 = eci2ecr_smhr(state,time);
threat1a(i,1) = time;
count = fprintf(fid,'%8.3f',threat1a(i,1));
threat1a(i,2:10) = state2;
for j=2:10
count = fprintf(fid,'\t%15.6f',threat1a(i,j));
end
count = fprintf(fid,'\n');
end
fclose(fid)

threat1 = csvread('threat009.csv');
[row col] = size(threat1);
fid = fopen('threat009_ecr.txt','w')
for i=1:row
state = threat1(i,2:10);
time = threat1(i,1);
state2 = eci2ecr_smhr(state,time);
threat1a(i,1) = time;
count = fprintf(fid,'%8.3f',threat1a(i,1));
threat1a(i,2:10) = state2;
for j=2:10
count = fprintf(fid,'\t%15.6f',threat1a(i,j));
end
count = fprintf(fid,'\n');
end
fclose(fid)

threat1 = csvread('threat010.csv');
[row col] = size(threat1);
fid = fopen('threat010_ecr.txt','w')
for i=1:row
state = threat1(i,2:10);
time = threat1(i,1);
state2 = eci2ecr_smhr(state,time);
threat1a(i,1) = time;
count = fprintf(fid,'%8.3f',threat1a(i,1));
threat1a(i,2:10) = state2;
for j=2:10
count = fprintf(fid,'\t%15.6f',threat1a(i,j));
end
count = fprintf(fid,'\n');
end
fclose(fid)

threat1 = csvread('threat011.csv');
[row col] = size(threat1);
fid = fopen('threat011_ecr.txt','w')
for i=1:row
state = threat1(i,2:10);
time = threat1(i,1);
state2 = eci2ecr_smhr(state,time);
threat1a(i,1) = time;
count = fprintf(fid,'%8.3f',threat1a(i,1));
threat1a(i,2:10) = state2;
for j=2:10
count = fprintf(fid,'\t%15.6f',threat1a(i,j));
end
count = fprintf(fid,'\n');
end
fclose(fid)

threat1 = csvread('threat012.csv');
[row col] = size(threat1);
fid = fopen('threat012_ecr.txt','w')
for i=1:row
state = threat1(i,2:10);
time = threat1(i,1);
state2 = eci2ecr_smhr(state,time);
threat1a(i,1) = time;
count = fprintf(fid,'%8.3f',threat1a(i,1));
threat1a(i,2:10) = state2;
for j=2:10
count = fprintf(fid,'\t%15.6f',threat1a(i,j));
end
count = fprintf(fid,'\n');
end
fclose(fid)

threat1 = csvread('threat013.csv');
[row col] = size(threat1);
fid = fopen('threat013_ecr.txt','w')
for i=1:row
state = threat1(i,2:10);
time = threat1(i,1);
state2 = eci2ecr_smhr(state,time);
threat1a(i,1) = time;
count = fprintf(fid,'%8.3f',threat1a(i,1));
threat1a(i,2:10) = state2;
for j=2:10
count = fprintf(fid,'\t%15.6f',threat1a(i,j));
end
count = fprintf(fid,'\n');
end
fclose(fid)

threat1 = csvread('threat014.csv');
[row col] = size(threat1);
fid = fopen('threat014_ecr.txt','w')
for i=1:row
state = threat1(i,2:10);
time = threat1(i,1);
state2 = eci2ecr_smhr(state,time);
threat1a(i,1) = time;
count = fprintf(fid,'%8.3f',threat1a(i,1));
threat1a(i,2:10) = state2;
for j=2:10
count = fprintf(fid,'\t%15.6f',threat1a(i,j));
end
count = fprintf(fid,'\n');
end
fclose(fid)

threat1 = csvread('threat015.csv');
[row col] = size(threat1);
fid = fopen('threat015_ecr.txt','w')
for i=1:row
state = threat1(i,2:10);
time = threat1(i,1);
state2 = eci2ecr_smhr(state,time);
threat1a(i,1) = time;
count = fprintf(fid,'%8.3f',threat1a(i,1));
threat1a(i,2:10) = state2;
for j=2:10
count = fprintf(fid,'\t%15.6f',threat1a(i,j));
end
count = fprintf(fid,'\n');
end
fclose(fid)

threat1 = csvread('threat016.csv');
[row col] = size(threat1);
fid = fopen('threat016_ecr.txt','w')
for i=1:row
state = threat1(i,2:10);
time = threat1(i,1);
state2 = eci2ecr_smhr(state,time);
threat1a(i,1) = time;
count = fprintf(fid,'%8.3f',threat1a(i,1));
threat1a(i,2:10) = state2;
for j=2:10
count = fprintf(fid,'\t%15.6f',threat1a(i,j));
end
count = fprintf(fid,'\n');
end
fclose(fid)

threat1 = csvread('threat017.csv');
[row col] = size(threat1);
fid = fopen('threat017_ecr.txt','w')
for i=1:row
state = threat1(i,2:10);
time = threat1(i,1);
state2 = eci2ecr_smhr(state,time);
threat1a(i,1) = time;
count = fprintf(fid,'%8.3f',threat1a(i,1));
threat1a(i,2:10) = state2;
for j=2:10
count = fprintf(fid,'\t%15.6f',threat1a(i,j));
end
count = fprintf(fid,'\n');
end
fclose(fid)

threat1 = csvread('threat018.csv');
[row col] = size(threat1);
fid = fopen('threat018_ecr.txt','w')
for i=1:row
state = threat1(i,2:10);
time = threat1(i,1);
state2 = eci2ecr_smhr(state,time);
threat1a(i,1) = time;
count = fprintf(fid,'%8.3f',threat1a(i,1));
threat1a(i,2:10) = state2;
for j=2:10
count = fprintf(fid,'\t%15.6f',threat1a(i,j));
end
count = fprintf(fid,'\n');
end
fclose(fid)

threat1 = csvread('threat019.csv');
[row col] = size(threat1);
fid = fopen('threat019_ecr.txt','w')
for i=1:row
state = threat1(i,2:10);
time = threat1(i,1);
state2 = eci2ecr_smhr(state,time);
threat1a(i,1) = time;
count = fprintf(fid,'%8.3f',threat1a(i,1));
threat1a(i,2:10) = state2;
for j=2:10
count = fprintf(fid,'\t%15.6f',threat1a(i,j));
end
count = fprintf(fid,'\n');
end
fclose(fid)

threat1 = csvread('threat020.csv');
[row col] = size(threat1);
fid = fopen('threat020_ecr.txt','w')
for i=1:row
state = threat1(i,2:10);
time = threat1(i,1);
state2 = eci2ecr_smhr(state,time);
threat1a(i,1) = time;
count = fprintf(fid,'%8.3f',threat1a(i,1));
threat1a(i,2:10) = state2;
for j=2:10
count = fprintf(fid,'\t%15.6f',threat1a(i,j));
end
count = fprintf(fid,'\n');
end
fclose(fid)

% threat1 = csvread('threat021.csv');
% [row col] = size(threat1);
% fid = fopen('threat021_ecr.txt','w')
% for i=1:row
% state = threat1(i,2:10);
% time = threat1(i,1);
% state2 = eci2ecr_smhr(state,time);
% threat1a(i,1) = time;
% count = fprintf(fid,'%8.3f',threat1a(i,1));
% threat1a(i,2:10) = state2;
% for j=2:10
% count = fprintf(fid,'\t%15.6f',threat1a(i,j));
% end
% count = fprintf(fid,'\n');
% end
% fclose(fid)
% 
% threat1 = csvread('threat022.csv');
% [row col] = size(threat1);
% fid = fopen('threat022_ecr.txt','w')
% for i=1:row
% state = threat1(i,2:10);
% time = threat1(i,1);
% state2 = eci2ecr_smhr(state,time);
% threat1a(i,1) = time;
% count = fprintf(fid,'%8.3f',threat1a(i,1));
% threat1a(i,2:10) = state2;
% for j=2:10
% count = fprintf(fid,'\t%15.6f',threat1a(i,j));
% end
% count = fprintf(fid,'\n');
% end
% fclose(fid)
% 
% threat1 = csvread('threat023.csv');
% [row col] = size(threat1);
% fid = fopen('threat023_ecr.txt','w')
% for i=1:row
% state = threat1(i,2:10);
% time = threat1(i,1);
% state2 = eci2ecr_smhr(state,time);
% threat1a(i,1) = time;
% count = fprintf(fid,'%8.3f',threat1a(i,1));
% threat1a(i,2:10) = state2;
% for j=2:10
% count = fprintf(fid,'\t%15.6f',threat1a(i,j));
% end
% count = fprintf(fid,'\n');
% end
% fclose(fid)
% 
% threat1 = csvread('threat024.csv');
% [row col] = size(threat1);
% fid = fopen('threat024_ecr.txt','w')
% for i=1:row
% state = threat1(i,2:10);
% time = threat1(i,1);
% state2 = eci2ecr_smhr(state,time);
% threat1a(i,1) = time;
% count = fprintf(fid,'%8.3f',threat1a(i,1));
% threat1a(i,2:10) = state2;
% for j=2:10
% count = fprintf(fid,'\t%15.6f',threat1a(i,j));
% end
% count = fprintf(fid,'\n');
% end
% fclose(fid)
% 
% threat1 = csvread('threat025.csv');
% [row col] = size(threat1);
% fid = fopen('threat025_ecr.txt','w')
% for i=1:row
% state = threat1(i,2:10);
% time = threat1(i,1);
% state2 = eci2ecr_smhr(state,time);
% threat1a(i,1) = time;
% count = fprintf(fid,'%8.3f',threat1a(i,1));
% threat1a(i,2:10) = state2;
% for j=2:10
% count = fprintf(fid,'\t%15.6f',threat1a(i,j));
% end
% count = fprintf(fid,'\n');
% end
% fclose(fid)
% 
% threat1 = csvread('threat026.csv');
% [row col] = size(threat1);
% fid = fopen('threat026_ecr.txt','w')
% for i=1:row
% state = threat1(i,2:10);
% time = threat1(i,1);
% state2 = eci2ecr_smhr(state,time);
% threat1a(i,1) = time;
% count = fprintf(fid,'%8.3f',threat1a(i,1));
% threat1a(i,2:10) = state2;
% for j=2:10
% count = fprintf(fid,'\t%15.6f',threat1a(i,j));
% end
% count = fprintf(fid,'\n');
% end
% fclose(fid)
% 
% threat1 = csvread('threat027.csv');
% [row col] = size(threat1);
% fid = fopen('threat027_ecr.txt','w')
% for i=1:row
% state = threat1(i,2:10);
% time = threat1(i,1);
% state2 = eci2ecr_smhr(state,time);
% threat1a(i,1) = time;
% count = fprintf(fid,'%8.3f',threat1a(i,1));
% threat1a(i,2:10) = state2;
% for j=2:10
% count = fprintf(fid,'\t%15.6f',threat1a(i,j));
% end
% count = fprintf(fid,'\n');
% end
% fclose(fid)
% 
% threat1 = csvread('threat028.csv');
% [row col] = size(threat1);
% fid = fopen('threat028_ecr.txt','w')
% for i=1:row
% state = threat1(i,2:10);
% time = threat1(i,1);
% state2 = eci2ecr_smhr(state,time);
% threat1a(i,1) = time;
% count = fprintf(fid,'%8.3f',threat1a(i,1));
% threat1a(i,2:10) = state2;
% for j=2:10
% count = fprintf(fid,'\t%15.6f',threat1a(i,j));
% end
% count = fprintf(fid,'\n');
% end
% fclose(fid)
% 
% threat1 = csvread('threat029.csv');
% [row col] = size(threat1);
% fid = fopen('threat029_ecr.txt','w')
% for i=1:row
% state = threat1(i,2:10);
% time = threat1(i,1);
% state2 = eci2ecr_smhr(state,time);
% threat1a(i,1) = time;
% count = fprintf(fid,'%8.3f',threat1a(i,1));
% threat1a(i,2:10) = state2;
% for j=2:10
% count = fprintf(fid,'\t%15.6f',threat1a(i,j));
% end
% count = fprintf(fid,'\n');
% end
% fclose(fid)
% 
% threat1 = csvread('threat030.csv');
% [row col] = size(threat1);
% fid = fopen('threat030_ecr.txt','w')
% for i=1:row
% state = threat1(i,2:10);
% time = threat1(i,1);
% state2 = eci2ecr_smhr(state,time);
% threat1a(i,1) = time;
% count = fprintf(fid,'%8.3f',threat1a(i,1));
% threat1a(i,2:10) = state2;
% for j=2:10
% count = fprintf(fid,'\t%15.6f',threat1a(i,j));
% end
% count = fprintf(fid,'\n');
% end
% fclose(fid)
% 
% threat1 = csvread('threat031.csv');
% [row col] = size(threat1);
% fid = fopen('threat031_ecr.txt','w')
% for i=1:row
% state = threat1(i,2:10);
% time = threat1(i,1);
% state2 = eci2ecr_smhr(state,time);
% threat1a(i,1) = time;
% count = fprintf(fid,'%8.3f',threat1a(i,1));
% threat1a(i,2:10) = state2;
% for j=2:10
% count = fprintf(fid,'\t%15.6f',threat1a(i,j));
% end
% count = fprintf(fid,'\n');
% end
% fclose(fid)
% 
% threat1 = csvread('threat032.csv');
% [row col] = size(threat1);
% fid = fopen('threat032_ecr.txt','w')
% for i=1:row
% state = threat1(i,2:10);
% time = threat1(i,1);
% state2 = eci2ecr_smhr(state,time);
% threat1a(i,1) = time;
% count = fprintf(fid,'%8.3f',threat1a(i,1));
% threat1a(i,2:10) = state2;
% for j=2:10
% count = fprintf(fid,'\t%15.6f',threat1a(i,j));
% end
% count = fprintf(fid,'\n');
% end
% fclose(fid)
% 
% threat1 = csvread('threat033.csv');
% [row col] = size(threat1);
% fid = fopen('threat033_ecr.txt','w')
% for i=1:row
% state = threat1(i,2:10);
% time = threat1(i,1);
% state2 = eci2ecr_smhr(state,time);
% threat1a(i,1) = time;
% count = fprintf(fid,'%8.3f',threat1a(i,1));
% threat1a(i,2:10) = state2;
% for j=2:10
% count = fprintf(fid,'\t%15.6f',threat1a(i,j));
% end
% count = fprintf(fid,'\n');
% end
% fclose(fid)
% 
% threat1 = csvread('threat034.csv');
% [row col] = size(threat1);
% fid = fopen('threat034_ecr.txt','w')
% for i=1:row
% state = threat1(i,2:10);
% time = threat1(i,1);
% state2 = eci2ecr_smhr(state,time);
% threat1a(i,1) = time;
% count = fprintf(fid,'%8.3f',threat1a(i,1));
% threat1a(i,2:10) = state2;
% for j=2:10
% count = fprintf(fid,'\t%15.6f',threat1a(i,j));
% end
% count = fprintf(fid,'\n');
% end
% fclose(fid)
% 
% threat1 = csvread('threat035.csv');
% [row col] = size(threat1);
% fid = fopen('threat035_ecr.txt','w')
% for i=1:row
% state = threat1(i,2:10);
% time = threat1(i,1);
% state2 = eci2ecr_smhr(state,time);
% threat1a(i,1) = time;
% count = fprintf(fid,'%8.3f',threat1a(i,1));
% threat1a(i,2:10) = state2;
% for j=2:10
% count = fprintf(fid,'\t%15.6f',threat1a(i,j));
% end
% count = fprintf(fid,'\n');
% end
% fclose(fid)
% 
% threat1 = csvread('threat036.csv');
% [row col] = size(threat1);
% fid = fopen('threat036_ecr.txt','w')
% for i=1:row
% state = threat1(i,2:10);
% time = threat1(i,1);
% state2 = eci2ecr_smhr(state,time);
% threat1a(i,1) = time;
% count = fprintf(fid,'%8.3f',threat1a(i,1));
% threat1a(i,2:10) = state2;
% for j=2:10
% count = fprintf(fid,'\t%15.6f',threat1a(i,j));
% end
% count = fprintf(fid,'\n');
% end
% fclose(fid)
% 
% threat1 = csvread('threat037.csv');
% [row col] = size(threat1);
% fid = fopen('threat037_ecr.txt','w')
% for i=1:row
% state = threat1(i,2:10);
% time = threat1(i,1);
% state2 = eci2ecr_smhr(state,time);
% threat1a(i,1) = time;
% count = fprintf(fid,'%8.3f',threat1a(i,1));
% threat1a(i,2:10) = state2;
% for j=2:10
% count = fprintf(fid,'\t%15.6f',threat1a(i,j));
% end
% count = fprintf(fid,'\n');
% end
% fclose(fid)
% 
% threat1 = csvread('threat038.csv');
% [row col] = size(threat1);
% fid = fopen('threat038_ecr.txt','w')
% for i=1:row
% state = threat1(i,2:10);
% time = threat1(i,1);
% state2 = eci2ecr_smhr(state,time);
% threat1a(i,1) = time;
% count = fprintf(fid,'%8.3f',threat1a(i,1));
% threat1a(i,2:10) = state2;
% for j=2:10
% count = fprintf(fid,'\t%15.6f',threat1a(i,j));
% end
% count = fprintf(fid,'\n');
% end
% fclose(fid)
% 
% threat1 = csvread('threat039.csv');
% [row col] = size(threat1);
% fid = fopen('threat039_ecr.txt','w')
% for i=1:row
% state = threat1(i,2:10);
% time = threat1(i,1);
% state2 = eci2ecr_smhr(state,time);
% threat1a(i,1) = time;
% count = fprintf(fid,'%8.3f',threat1a(i,1));
% threat1a(i,2:10) = state2;
% for j=2:10
% count = fprintf(fid,'\t%15.6f',threat1a(i,j));
% end
% count = fprintf(fid,'\n');
% end
% fclose(fid)
% 
% threat1 = csvread('threat040.csv');
% [row col] = size(threat1);
% fid = fopen('threat040_ecr.txt','w')
% for i=1:row
% state = threat1(i,2:10);
% time = threat1(i,1);
% state2 = eci2ecr_smhr(state,time);
% threat1a(i,1) = time;
% count = fprintf(fid,'%8.3f',threat1a(i,1));
% threat1a(i,2:10) = state2;
% for j=2:10
% count = fprintf(fid,'\t%15.6f',threat1a(i,j));
% end
% count = fprintf(fid,'\n');
% end
% fclose(fid)