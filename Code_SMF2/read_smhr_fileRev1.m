function [ smhr ] = read_smhr_fileRev1( filename )
% this routine will read a single smhr file
% and load it into memory to allow for the
% conversion of a set of asc files,one per object
%cd H:\MDSET\Trajectories\SMHR_to_58Col
tic;
fid = fopen(filename,'r');

%
object_data_template = struct('name','', ...
    'type', [], ...
    'pbv_assoc_num',[], ...
    'number',[], ...
    'category',[], ...
    'critical_path_object',[], ...
    'parent_object_number',[], ...
    'parent_velocity',zeros(3,1), ...
    'ballistic_coefficient',[], ...
    'seq_number_for_object_type',[], ...
    'destruction_lat',[], ...
    'destruction_lon',[], ...
    'destruction_alt',[], ...
    'destruction_time',[], ...
    'reentry_angle',[], ...
    'reentry_time',[], ...
    'apogee_altitude',[], ...
    'apogee_time',[], ...
    'aimpoint_id', [], ...
    'aimpoint_lat', [], ...
    'aimpoint_lon', [], ...
    'aimpoint_alt', [], ...
    'state_data',struct([]));

state_template = struct('time', [], ...
    'rv_assoc_num', [], ...
    'on_critical_path',[], ...
    'rv_assoc', [], ...
    'event_status_flag', [], ...
    'event_flag', [], ...
    'engine_status_flag', [], ...
    'guidance_direction_flag',[], ...
    'guidance_mode',[], ...
    'fuel_rate', [], ...
    'ball_coef', [], ...
    'aerodynamic_mode', [], ...
    'pos',[], ...
    'vel',[], ...
    'acc',[], ...
    'lateral_acc',[], ...
    'axial_acc',[], ...
    'y_body_frame_acc',[], ...
    'z_body_frame_acc',[], ...
    'body_axis', [], ...
    'orientation_mode',[], ...
    'body_phi',[], ...
    'body_theta',[], ...
    'body_psi',[], ...
    'body_rate_phi',[], ...
    'body_rate_theta',[], ...
    'body_rate_psi',[], ...
    'moment_of_inertia_phi',[], ...
    'moment_of_inertia_theta',[], ...
    'moment_of_inertia_psi',[], ...
    'roll_pitch_poi',[], ...
    'roll_yaw_poi',[], ...
    'pitch_yaw_poi',[], ...
    'quat',[], ...
    'quat_rate',[], ...
    'flight_path_angle',[], ...
    'precession_ang',[], ...
    'precession_rate',[], ...
    'spin_ang',[], ...
    'spin_rate',[], ...
    'center_gravity',[], ...
    'aoa_total',[], ...
    'aoa_pitch',[], ...
    'aoa_yaw',[], ...
    'thrust',[], ...
    'vacuum_thrust',[], ...
    'thrust_mode',[], ...
    'thrust_direction',[], ...
    'mass',[], ...
    'static_margin_pitch',[], ...
    'static_stability',[], ...
    'static_margin_yaw',[], ...
    'dynamic_pressure',[], ...
    'mach',[], ...
    'cd',[]);

% Read 3 comment lines and 2 other lines
for ii=1:5
    fgetl(fid);
end

% Record 2
line = fgetl(fid);
C = textscan(line,'%40c   %8s',1);
smhr.missile_system = C{1};
smhr.date = C{2};

% Skip record 3
line = fgetl(fid);

% Record 4 - Gravity model
line = fgetl(fid);
C = textscan(line,'%d %d %d %d %d %d %f %s',1);
smhr.earth_gravity_model = C{1};
smhr.earth_gravity_model_components = [C{2} C{3}];
smhr.atmospheric_model = C{4};
smhr.rotation = C{5};
smhr.rotation_coordinate_frame = C{6};
smhr.reentry_altitude = C{7};
% C{8} ignore

% Record 5
line = fgetl(fid);
C = textscan(line,'%d%25c%d%d%d%d%d%d%d%d%d%d%f%f%f%f%f',1);
smhr.missile_id = C{1};
smhr.system_name = C{2};
smhr.system_type = C{3};
smhr.system_ops = C{4};
smhr.nPBVs = C{5};
smhr.nRVs = C{6};
smhr.nobjects = C{7};
smhr.BBO_inertial_range = C{8};
smhr.BBO_ground_range = C{9};
smhr.BBO_altitude = C{10};
smhr.BBO_flight_path = C{11};
smhr.BBO_azimuth = C{12};

% Record 6
line = fgetl(fid);
C = textscan(line,'%f%f%d%f%f%f%f%f%d%16s%u',1);
smhr.BBO_time = C{1};
smhr.liftoff_time  = C{2};
smhr.launch_cmplx = C{3};
smhr.launch_lat = C{4};
smhr.launch_lon = C{5};
smhr.launch_alt = C{6};
smhr.launch_time = C{7};
smhr.launch_az = C{8};
smhr.num_objs = C{9};
smhr.unique_id = C{10};
smhr.random_seed = C{11};

object_data = repmat(object_data_template,1,smhr.num_objs);
[pathstr,shortfilename,ext]=fileparts(filename);
waitstr=strcat('Please wait-now importing smhr file-',shortfilename);
%h1 = waitbar(0,waitstr,'Name','Read SMHR File');
numobjects=smhr.num_objs;
dispstr=strcat('Num of objects found=',num2str(numobjects,5));
disp(dispstr)
for ii=1:smhr.num_objs
    % Record 7
    line = fgetl(fid);
    C = textscan(line,'%20c%d%d%d%d%d%d%f%f%f%f%d',1);
    object_data(ii).name = C{1};
    object_data(ii).type= C{2};
    object_data(ii).pbv_assoc_num = C{3};
    object_data(ii).number = C{4};
    object_data(ii).category = C{5};
    object_data(ii).critical_path_object = C{6};
    object_data(ii).parent_object_number = C{7};
    object_data(ii).parent_velocity = [C{8} C{9} C{10}];
    object_data(ii).ballistic_coefficient = C{11};
    object_data(ii).seq_number_for_object_type = C{12};
    
    % Record 8
    line = fgetl(fid);
    C = textscan(line,'%f%f%f%f%f%f%f%f',1);
    object_data(ii).destruction_lat = C{1};
    object_data(ii).destruction_lon = C{2};
    object_data(ii).destruction_alt = C{3};
    object_data(ii).destruction_time = C{4};
    object_data(ii).reentry_angle = C{5};
    object_data(ii).reentry_time = C{6};
    object_data(ii).apogee_altitude = C{7};
    object_data(ii).apogee_time = C{8};

    % Record 9
    line = fgetl(fid);
    C = textscan(line,'%5d%f%f%f%d',1);
    object_data(ii).aimpoint_id = C{1};
    object_data(ii).aimpoint_lat = C{2};
    object_data(ii).aimpoint_lon = C{3};
    object_data(ii).aimpoint_alt = C{4};
    n = C{5};
    dispstr=strcat('Now processing object-',num2str(ii,5),'-of-',...
    num2str(numobjects,5),'-which has-',num2str(n,5),'-records');
    disp(dispstr);
    state = repmat(state_template,1,n);

    for jj=1:n
        % Record 10

        line = fgetl(fid);
        C = textscan(line,'%f%d%d%d%d%d%d%d%f%f%d%f%f%f',1);
        state(jj).time = C{1};
        state(jj).rv_assoc_num = C{2};
        state(jj).on_critical_path = C{3};
        state(jj).event_status_flag = C{4};
        state(jj).event_flag = C{5};
        state(jj).engine_status_flag = C{6};
        state(jj).guidance_direction_flag = C{7};
        state(jj).guidance_mode = C{8};
        state(jj).fuel_rate = C{9};
        state(jj).ball_coef = C{10};
        state(jj).aerodynamic_mode = C{11};
        state(jj).pos = [C{12} C{13} C{14}];
        
        % Record 11
        line = fgetl(fid);
        C = textscan(line,'%f%f%f%f%f%f%f%f%f%f',1);
        state(jj).vel = [C{1} C{2} C{3}];
        state(jj).acc = [C{4} C{5} C{6}];
        state(jj).lateral_acc = C{7};
        state(jj).axial_acc = C{8};
        state(jj).y_body_frame_acc = C{9};
        state(jj).z_body_frame_acc = C{10};

        % Record 12
        line = fgetl(fid);
        C = textscan(line,'%f%f%f%d',1);
        state(jj).body_axis = [C{1} C{2} C{3}];
        state(jj).orientation_mode = C{4};
        
        % Record 13
        line = fgetl(fid);
        C = textscan(line,'%f%f%f%f%f%f%f%f%f%f%f%f',1);
        state(jj).body_phi = C{1};
        state(jj).body_theta = C{2};
        state(jj).body_psi = C{3};
        state(jj).body_rate_phi = C{4};
        state(jj).body_rate_theta = C{5};
        state(jj).body_rate_psi = C{6};
        state(jj).moment_of_inertia_phi = C{7};
        state(jj).moment_of_inertia_theta = C{8};
        state(jj).moment_of_inertia_psi = C{9};
        state(jj).roll_pitch_poi = C{10};
        state(jj).roll_yaw_poi = C{11};
        state(jj).pitch_yaw_poi = C{12};
        
        % Record 14
        line = fgetl(fid);
        C = textscan(line,'%f%f%f%f%f%f%f%f',1);
        state(jj).quat = [C{1} C{2} C{3} C{4}];
        state(jj).quat_rate = [C{5} C{6} C{7} C{8}];
        
        % Record 15
        line = fgetl(fid);
        C = textscan(line,'%f%f%f%f%f%f%f%f%f%f%f',1);
        state(jj).flight_path_angle = C{1};
        state(jj).precession_ang = C{2};
        state(jj).precession_rate = C{3};
        state(jj).spin_ang = C{4};
        state(jj).spin_rate = C{5};
        state(jj).center_gravity = [C{6} C{7} C{8}];
        state(jj).aoa_total = C{9};
        state(jj).aoa_pitch = C{10};
        state(jj).aoa_yaw = C{11};
        
        % Record 16
        line = fgetl(fid);
        C = textscan(line,'%f%f%d%f%f%f',1);
        state(jj).thrust = C{1};
        state(jj).vacuum_thrust = C{2};
        state(jj).thrust_mode = C{3};
        state(jj).thrust_direction = [C{4} C{5} C{6}];
        
        % Record 17
        line = fgetl(fid);
        C = textscan(line,'%f%f%f%f%f%f%f',1);
        state(jj).mass = C{1};
        state(jj).static_margin_pitch = C{2};
        state(jj).static_stability = C{3};
        state(jj).static_margin_yaw = C{4};
        state(jj).dynamic_pressure = C{5};
        state(jj).mach = C{6};
        state(jj).cd = C{7};
        
    end

    object_data(ii).state_data = state;
end
%close(h1);
smhr.object_data = object_data;

fclose(fid);
elapsed_time=toc;
dispstr=strcat('Closed file-',filename,'-took-',num2str(elapsed_time),'-sec to read');
disp(dispstr);
end

