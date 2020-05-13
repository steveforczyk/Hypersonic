refdir = 'M:\MET-I\AAT\Personal_Folders\ThreatData\L167aD04P01v2\Trajectory\L167a_Unpo_NYC_01';
outdir = 'M:\MET-I\AAT\Personal_Folders\ThreatData\L167aD04P01v2\Trajectory\L167a_Unpo_NYC_01_Rotating';
headers = 4;

if ~exist(outdir)
    mkdir(outdir)
end

allfiles = dir(refdir);

for idx = 1:length(allfiles)
    if ~isempty(strfind(allfiles(idx).name,'.asc'))
        
        file_name = fullfile(refdir,allfiles(idx).name);
        
        filedata = importdata(file_name,' ',headers);
        
        token = strsplit(filedata.textdata{headers-1,1});
        
        %write new file headers
        fileID = fopen(fullfile(outdir,allfiles(idx).name),'w');
        for ii = 1:(headers-2)
            fprintf(fileID,'%s\n',filedata.textdata{ii,1});
        end
        for jj= 1:length(token)
            if ~isempty(token{jj})
                fprintf(fileID,'%18.7s',token{jj});
            end
        end
        fprintf(fileID,'\n',token{jj});
        fprintf(fileID,'%s\n',sprintf('%18.7s',filedata.textdata{headers,:}));
        
        %pull pos,vel, and accel vectors from original file and convert
        S = dlmread(file_name, '', headers, 0);
        time =  [S(:, 1)].';
        states_ecef = [S(:, 9) , S(:, 15), S(:, 21),...
            S(:, 10), S(:, 16), S(:, 22),...
            S(:, 11), S(:, 17), S(:, 23)].';
        states_eci = [ecef2eci(states_ecef, time)].'; %convert
        col_indices = [9,15,21,10,16,22,11,17,23];
        S_eci = S;
        S_eci(:,col_indices) = states_eci; %place new values into old array
        
        %write data
        for kk = 1:length(S_eci(:,1))
            %for ll = 1:length(S_eci(1,:))
            fprintf(fileID,'%18.7f',S_eci(kk,:));
            fprintf(fileID,'\n');
        end
        fclose(fileID);
    end
end
