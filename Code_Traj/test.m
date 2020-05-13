




file_name = fullfile(pwd, 'L167aD12P04v1_S03_0002_l2i.asc');

S = dlmread(file_name, '', 2, 0);
                
time =  [S(:, 1)]';

states_eci = [S(:, 9) , S(:, 15), S(:, 21),...
              S(:, 10), S(:, 16), S(:, 22),...
              S(:, 11), S(:, 17), S(:, 23)]';
          
states_ecef = eci2ecef(states_eci, time);

pos_ecef = [states_ecef(1, :); states_ecef(4, :); states_ecef(7, :)];
vel_ecef = [states_ecef(2, :); states_ecef(5, :); states_ecef(8, :)];   


figure(35); hold all;
axesm('MapProjection', 'globe',  'Geoid', [6371000,0])
display_globe('outline');
grid on;

plot3(pos_ecef(1,:), pos_ecef(2,:), pos_ecef(3,:), 'r-', 'LineWidth', 3)





















%x