% This script will read an SMHR file and convert it to separate
% 58 col or .asc files
%
% Written By: Stephen Forczyk
% Created: Feb 23,2019
% Revised:----
% Classification: Unclassified

clc
clear all
global smhrfile;
global ThreatLaunchLat ThreatLaunchLon ThreatLaunchTime;
global ThreatAimLat ThreatAimLon ThreatECITraj ThreatImpactTime;
global ThreatGroundRange ThreatTimeStep ThreatTrajLLa;
global ThreatTraj iTgtTraj;
global LaunchLat LaunchLon LaunchAlt LaunchTime;
global CoordFrame Rotation;
global AimpointLat AimpointLon AimpointAlt;
global ApogeeTime ApogeeAlt;
global DestructTime DestructAlt DestructLat DestructLon;
global Times ballcoeff;
global VECIX VECIY VECIZ;
global ECIX ECIY ECIZ;
global AECIX AECIY AECIZ;
global Lateral_Accel Body_Accel;
global Y_BodyAccel Z_BodyAccel;
global X_BodAxis Y_BodAxis Z_BodAxis;
global Body_Phi Body_Theta Body_Psi;
global Body_Rate_Phi Body_Rate_Theta Body_Rate_Psi;
global RIXX RIYY RIZZ;
global Roll_Pitch Roll_Yaw Pitch_Yaw; 
global Flight_Path_Angle Precession_Angle Precession_Rate;
global Spin_Angle Spin_Rate;
global COGX COGY COGZ;
global Alfa Beta Mass;
global Static_Margin_Pitch Static_Margin_Yaw Q RMach;
global CDrag Alfat;
global AltM GDLat GDLon VMag;
global PiENU tdel ViENU AiENU;
global Phinu Thanu Psinu cmacg grienu tliftoff;

global widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;
global vert2 hor2 machine;
global chart_time;
global Fz1 Fz2;
global idirector mov izoom iwindow;
global matpath;
global jpegpath militarypath;
global smhrpath excelpath;
global ipowerpoint PowerPointFile scaling stretching padding;
excelpath='H:\MDSET\Trajectories\Excel_Files\';
matpath='H:\MDSET\Trajectories\MAT_Files\';
jpegpath='H:\MDSET\Trajectories\Jpeg_Files\';
smhrpath='H:\MDSET\Trajectories\SMHR_to_58Col\';
smhrfile='DPRK_2.smhr';
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
tic;
% Navigate to the smhr trajectory File folder and load it into memory
eval(['cd ' smhrpath(1:length(smhrpath)-1)]);
[ smhr ] = read_smhr_fileRev1(smhrfile);
% Let find out what each of the object names is
ObjectName=cell(1,1);
ObjectCode=cell(1,1);
ConvertObjectName=cell(1,1);
ThreatName=deblank(smhr.system_name);
numobjects=length(smhr.object_data);
igood=0;
for n=1:numobjects
    ObjectName{n,1}=deblank(smhr.object_data(n).name);
    itype=smhr.object_data(n).type;
    ObjectType{n,1}=smhr.object_data(n).type;
    if(itype<1000)
        igood=igood+1;
        ConvertObjectName{igood,1}=deblank(smhr.object_data(n).name);
%        ConvertObjectName{igood,3}=deblank(smhr.object_data(n).name);
        ConvertObjectIndex(igood,1)=n;
    end
end
numconvert=igood;
UniqueNames=unique(ConvertObjectName);
numUniqueNames=length(UniqueNames);
% Now find out how many objects share each of these unique names
for k=1:numUniqueNames
    uname=UniqueNames{k,1};
    ifnd=0;
    for n=1:numconvert
        cname=ConvertObjectName{n,1};
        a1=strcmp(uname,cname);
        if(a1==1)
            ifnd=ifnd+1;
            if(ifnd>1)
                unameplus=strcat(uname,'-',num2str(ifnd));
            else
                unameplus=uname;
            end
            ConvertObjectName{n,2}=unameplus;
            
        end
    end
    UniqueNames{k,2}=ifnd;
end
ab=3;
% Now for those objects that multiple occurances assign new unique names

% Now extract the data needed just for these objects
for n=1:numconvert
    ind=ConvertObjectIndex(n,1);
    [nrows]=length(smhr.object_data(ind).state_data);
    Times=zeros(nrows-1,1);
    ballcoeff=zeros(nrows-1,1);
    Alfat=zeros(nrows-1,1);
    ECIX=zeros(nrows-1,1);
    ECIY=zeros(nrows-1,1);
    ECIZ=zeros(nrows-1,1);
    VECIX=zeros(nrows-1,1);
    VECIY=zeros(nrows-1,1);
    VECIZ=zeros(nrows-1,1);
    AECIX=zeros(nrows-1,1);
    AECIY=zeros(nrows-1,1);
    AECIZ=zeros(nrows-1,1);
    X_BodAxis=zeros(nrows-1,1);
    Y_BodAxis=zeros(nrows-1,1);
    Z_BodAxis=zeros(nrows-1,1);
    Lateral_Accel=zeros(nrows-1,1);
    Body_Accel=zeros(nrows-1,1);
    Y_BodyAccel=zeros(nrows-1,1);
    Z_BodyAccel=zeros(nrows-1,1);
    X_BodAxis=zeros(nrows-1,1);
    Y_BodAxis=zeros(nrows-1,1);
    Z_BodAxis=zeros(nrows-1,1);
    Body_Phi = zeros(nrows-1,1);
    Body_Theta = zeros(nrows-1,1);
    Body_Psi = zeros(nrows-1,1);
    Body_Rate_Phi = zeros(nrows-1,1);
    Body_Rate_Theta = zeros(nrows-1,1);
    Body_Rate_Psi = zeros(nrows-1,1);
    Roll_Pitch = zeros(nrows-1,1);
    Roll_Yaw = zeros(nrows-1,1);
    Pitch_Yaw=zeros(nrows-1,1);
    Flight_Path_Angle=zeros(nrows-1,1);
    Precession_Angle=zeros(nrows-1,1);
    Precession_Rate=zeros(nrows-1,1);
    Spin_Angle=zeros(nrows-1,1);
    Spin_Rate=zeros(nrows-1,1);
    RIXX=zeros(nrows-1,1);
    RIYY=zeros(nrows-1,1);
    RIZZ=zeros(nrows-1,1);
    COGX=zeros(nrows-1,1);
    COGY=zeros(nrows-1,1);
    COGZ=zeros(nrows-1,1);
    Alfa=zeros(nrows-1,1);
    Beta=zeros(nrows-1,1);
    Mass=zeros(nrows-1,1);
    Static_Margin_Pitch=zeros(nrows-1,1);
    Static_Margin_Yaw=zeros(nrows-1,1);
    Q=zeros(nrows-1,1);
    RMach=zeros(nrows-1,1);
    CDrag=zeros(nrows-1,1);
    AltM=zeros(nrows-1,1);
    GDLat=zeros(nrows-1,1);
    GDLon=zeros(nrows-1,1);
    VMag=zeros(nrows-1,1);
    PiENU=zeros(nrows-1,3);
    ViENU=zeros(nrows-1,3);
    AiENU=zeros(nrows-1,3);
    Phinu=zeros(nrows-1,1);
    Thanu=zeros(nrows-1,1);
    Psinu=zeros(nrows-1,1);
    tdel=zeros(nrows-1,1);
    cmacg=zeros(nrows-1,1);
    grienu=zeros(nrows-1,1);
    %tliftoff=LaunchTime*ones(nrows-1,1);
    tliftoff=zeros(nrows-1,1);
    LaunchLat=smhr.launch_lat;
    LaunchLon=smhr.launch_lon;
    LaunchAlt=smhr.launch_alt;
    LaunchTime=smhr.launch_time;
    Rotation=smhr.rotation;
    CoordFrame=smhr.rotation_coordinate_frame;
    AimpointLat=smhr.object_data(1,ind).aimpoint_lat;
    AimpointLon=smhr.object_data(1,ind).aimpoint_lon;
    AimpointAlt=smhr.object_data(1,ind).aimpoint_alt;
    DestructTime=smhr.object_data(1,ind).destruction_time;
    DestructLat=smhr.object_data(1,ind).destruction_lat;
    DestructLon=smhr.object_data(1,ind).destruction_lon;
    DestructAlt=smhr.object_data(1,ind).destruction_alt;
    spheroid = referenceEllipsoid('GRS 80');
% Extract Each Item As They Are Needed
    for m=2:nrows-1
        Times(m-1,1)=smhr.object_data(1,ind).state_data(m).time;
        ballcoeff(m-1,1)=smhr.object_data(1,ind).state_data(m).ball_coef;
        pos=smhr.object_data(1,ind).state_data(m).pos;
        ECIX(m-1,1)=pos(1,1);
        ECIY(m-1,1)=pos(1,2);
        ECIZ(m-1,1)=pos(1,3);
        vel=smhr.object_data(1,ind).state_data(m).vel;
        VECIX(m-1,1)=vel(1,1);
        VECIY(m-1,1)=vel(1,2);
        VECIZ(m-1,1)=vel(1,3);
        acc=smhr.object_data(1,ind).state_data(m).acc;
        AECIX(m-1,1)=acc(1,1);
        AECIY(m-1,1)=acc(1,2);
        AECIZ(m-1,1)=acc(1,3);
        Lateral_Accel(m-1,1)=smhr.object_data(1,ind).state_data(m).lateral_acc;
        Body_Accel(m-1,1)=smhr.object_data(1,ind).state_data(m).axial_acc;
        Y_BodyAccel(m-1,1)=smhr.object_data(1,ind).state_data(m).y_body_frame_acc;
        Z_BodyAccel(m-1,1)=smhr.object_data(1,ind).state_data(m).z_body_frame_acc;
        bodyaxis=smhr.object_data(1,ind).state_data(m).body_axis;
        X_BodAxis(m-1,1)=bodyaxis(1,1);
        Y_BodAxis(m-1,1)=bodyaxis(1,2);
        Z_BodAxis(m-1,1)=bodyaxis(1,3);
        Body_Phi(m-1,1)=smhr.object_data(1,ind).state_data(m).body_phi;
        Body_Theta(m-1,1)=smhr.object_data(1,ind).state_data(m).body_theta;
        Body_Psi(m-1,1)=smhr.object_data(1,ind).state_data(m).body_psi;
        Body_Rate_Phi(m-1,1)=smhr.object_data(1,ind).state_data(m).body_rate_phi;
        Body_Rate_Theta(m-1,1)=smhr.object_data(1,ind).state_data(m).body_rate_theta;
        Body_Rate_Psi(m-1,1)=smhr.object_data(1,ind).state_data(m).body_rate_psi;
        RIXX(m-1,1)=smhr.object_data(1,ind).state_data(m).moment_of_inertia_phi;
        RIYY(m-1,1)=smhr.object_data(1,ind).state_data(m).moment_of_inertia_theta;
        RIZZ(m-1,1)=smhr.object_data(1,ind).state_data(m).moment_of_inertia_psi;
        Roll_Pitch(m-1,1)=smhr.object_data(1,ind).state_data(m).roll_pitch_poi;
        Roll_Yaw(m-1,1)=smhr.object_data(1,ind).state_data(m).roll_yaw_poi;
        Pitch_Yaw(m-1,1)=smhr.object_data(1,ind).state_data(m).pitch_yaw_poi;
        Flight_Path_Angle(m-1,1)=smhr.object_data(1,ind).state_data(m).flight_path_angle;
        Precession_Angle(m-1,1)=smhr.object_data(1,ind).state_data(m).precession_ang;
        Precession_Rate(m-1,1)=smhr.object_data(1,ind).state_data(m).precession_rate;
        Spin_Angle(m-1,1)=smhr.object_data(1,ind).state_data(m).spin_ang;
        Spin_Rate(m-1,1)=smhr.object_data(1,ind).state_data(m).spin_rate;
        cog=smhr.object_data(1,ind).state_data(m).center_gravity;
        COGX(m-1,1)=cog(1,1);
        COGY(m-1,1)=cog(1,2);
        COGZ(m-1,1)=cog(1,3);
        Alfat(m-1,1)=smhr.object_data(1,ind).state_data(m).aoa_total;
        Alfa(m-1,1)=smhr.object_data(1,ind).state_data(m).aoa_pitch;
        Beta(m-1,1)=smhr.object_data(1,ind).state_data(m).aoa_yaw;
        Mass(m-1,1)=smhr.object_data(1,ind).state_data(m).mass;
        Static_Margin_Pitch(m-1,1)=smhr.object_data(1,ind).state_data(m).static_margin_pitch;
        Static_Margin_Yaw(m-1,1)=smhr.object_data(1,ind).state_data(m).static_margin_yaw;
        Q(m-1,1)=smhr.object_data(1,ind).state_data(m).dynamic_pressure;
        RMach(m-1,1)=smhr.object_data(1,ind).state_data(m).mach;
        CDrag(m-1,1)=smhr.object_data(1,ind).state_data(m).cd;
% Now compute some of the missing quantities not present in the smhr file
        eci(1,1)=Times(m-1,1);
        eci(1,2)=ECIX(m-1,1);
        eci(1,3)=ECIY(m-1,1);
        eci(1,4)=ECIZ(m-1,1);
        eci(1,5)=VECIX(m-1,1);
        eci(1,6)=VECIY(m-1,1);
        eci(1,7)=VECIZ(m-1,1);
        lla=eci2lla(eci);
        AltM(m-1,1)=lla(1,4);
        GDLat(m-1,1)=lla(1,2);
        GDLon(m-1,1)=lla(1,3);
        VMag(m-1,1)=sqrt(VECIX(m-1,1)^2 + VECIY(m-1,1)^2 + VECIZ(m-1,1)^2);
        ecef=eci2ecf(eci);
        EFX=ecef(1,2);
        EFY=ecef(1,3);
        EFZ=ecef(1,4);
        [xEast,yNorth,zUp] = ecef2enu(EFX,EFY,EFZ,LaunchLat,LaunchLon,LaunchAlt,spheroid);
        PiENU(m-1,1)=xEast;
        PiENU(m-1,2)=yNorth;
        PiENU(m-1,3)=zUp;
        [arclen,az] = distance(LaunchLat,LaunchLon,GDLat(m-1,1),GDLon(m-1,1),spheroid);
        grienu(m-1,1)=arclen;
    end
    if(n==22)
        ab=2;
    end
% Now write this data to a unique file
filenamestub=ConvertObjectName{n,2};
filename=strcat(filenamestub,'.asc');
fid=fopen(filename,'w');
if(fid>0)
    dispstr=strcat('Opened file-',filename,'-for writing');
    disp(dispstr);
str1a='          ctime           grienu            alt         alfat        fpangi        preang          tdel';
str1b='          xcg            pi(1)            pi(2)            pi(3)         pienu(1)         pienu(2)         pienu(3)';
str1c='    vi(1)            vi(2)            vi(3)         vienu(1)         vienu(2)         vienu(3)           vid(1)'; 
str1d='    vid(2)           vid(3)         aienu(1)         aienu(2)         aienu(3)           asb(1)           asblat';
str1e='    phi            theta              psi            phinu            thanu            psinu           brt(1)';
str1f='    brt(2)           brt(3)       betamis            rmass     xcppitch       xcpyaw             vmag';
str1g='    rixx                riyy                rizz         tliftoff        rmach           asb(2)';
str1h='    asb(3)              q          alfa          beta           tymmis            gdlat            gdlon';
str1i='    cd        cmacg       true_tflit'; 
str1=strcat(str1a,str1b,str1c,str1d,str1e,str1f,str1g,str1h,str1i);
str1len=length(str1);
str2a='        seconds           meters         meters       degrees       degrees       degrees        newtons';
str2b='        meters         meters           meters           meters           meters           meters';
str2c='    meters              m/s              m/s              m/s              m/s              m/s ';
str2d='    m/s           m/s**2           m/s**2           m/s**2           m/s**2           m/s**2           m/s**2';
str2e='    m/s**2           m/s**2          degrees          degrees          degrees          degrees          degrees';
str2f='    degrees          deg/sec          deg/sec          deg/sec       kg/m**2        kilograms       meters';
str2g='    meters              m/s             kg-m**2             kg-m**2             kg-m**2          seconds';
str2h='    none           m/s**2           m/s**2        nt/m**2       degrees       degrees          seconds';
str2i='    degrees          degrees           none          per          seconds ';
str2=strcat(str2a,str2b,str2c,str2d,str2e,str2f,str2g,str2h,str2i);
str2len=length(str1);
% Now write each timepoint in ascending order
    starttime=-1E10;
    fprintf(fid,'%s\n',str1);
    fprintf(fid,'%s\n',str2);
    for kk=1:nrows-1
        nowtime=Times(kk,1);
        if(nowtime>starttime)
            starttime=nowtime;
            fprintf(fid,'   %12.6f',Times(kk,1)); %1
            if(grienu(kk,1)<1E6)
                fprintf(fid,'    %12.6f    %12.4f',grienu(kk,1),AltM(kk,1)); %3
            else
                fprintf(fid,'   %12.6f    %12.4f',grienu(kk,1),AltM(kk,1)); %3
            end
            fprintf(fid,'%12.3f   %12.3f   %12.3f',Alfat(kk,1),Flight_Path_Angle(kk,1),Precession_Angle(kk,1)); %6
            fprintf(fid,'%12.4f    %12.3f    %16.6f',tdel(kk,1),COGX(kk,1),ECIX(kk,1));%9
            fprintf(fid,'%16.6f    %16.6f    %16.6f',ECIY(kk,1),ECIZ(kk,1),PiENU(kk,1));%12
            fprintf(fid,'%16.6f    %16.6f    %16.6f',PiENU(kk,2),PiENU(kk,3),VECIX(kk,1));%15
            fprintf(fid,'%16.6f    %16.6f    %16.6f',VECIY(kk,1),VECIZ(kk,1),ViENU(kk,1));%18
            fprintf(fid,'%16.6f    %16.6f',ViENU(kk,2),ViENU(kk,3));%20
            fprintf(fid,'%16.6f    %16.6f    %16.6f',AECIX(kk,1),AECIY(kk,1),AECIZ(kk,1));%23
            fprintf(fid,'%16.6f    %16.6f    %16.6f',AiENU(kk,1),AiENU(kk,2),AiENU(kk,3));%26
            fprintf(fid,'%12.6f    %12.6f',Body_Accel(kk,1),Lateral_Accel(kk,1));%28
            fprintf(fid,'%16.6f    %16.6f    %16.6f',Body_Phi(kk,1),Body_Theta(kk,1),Body_Psi(kk,1));%31
            fprintf(fid,'%16.6f    %16.6f    %16.6f',Phinu(kk,1),Thanu(kk,1),Psinu(kk,1));%34
            fprintf(fid,'%16.6f    %16.6f    %16.6f',Body_Rate_Phi(kk,1),Body_Rate_Theta(kk,1),Body_Rate_Psi(kk,1));%37
            fprintf(fid,'%12.3f    %12.6f',ballcoeff(kk,1),Mass(kk,1));%39
            fprintf(fid,'%16.6f    %16.6f    %16.6f',Static_Margin_Pitch(kk,1),Static_Margin_Yaw(kk,1),VMag(kk,1));%42
            fprintf(fid,'%16.9f    %16.9f    %16.9f',RIXX(kk,1),RIYY(kk,1),RIZZ(kk,1));%45
            fprintf(fid,'%16.6f    %16.2f',tliftoff(kk,1),RMach(kk,1));%48
            fprintf(fid,'%16.6f    %16.6f',Y_BodyAccel(kk,1),Z_BodyAccel(kk,1));%49
            fprintf(fid,'%16.6f    %16.6f    %16.6f',Q(kk,1),Alfa(kk,1),Beta(kk,1));%52
            fprintf(fid,'%12.6f    %16.6f    %16.6f',Times(kk,1),GDLat(kk,1),GDLon(kk,1));%55
            fprintf(fid,'%16.4f    %16.2f    %12.6f\n',CDrag(kk,1),cmacg(kk,1),Times(kk,1));%58
        end
    end
    fclose(fid);
    dispstr=strcat('finished writing file-',filename);
    disp(dispstr);
    ab=1;
else
    dispstr=strcat('Could not open file-',filename,'-for writing');
    disp(dispstr)
    
end
end
ab=1;