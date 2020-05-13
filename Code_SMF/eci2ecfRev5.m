function ecef = eci2ecfRev5(data_eci, t)                       
% ECI2ECEF converts eci points to ecf
%
% Expected Inputs:
%	data_eci	(double array)      [x y z]' in meters
%                                   3 x N, 6 x N, or 9 x N array, one column
%                                   per point 
%                                       OR
%                                   [x xdot y ydot z zdot]' in meters, and
%                                   meters/sec 
%                                       OR
%                                   [x xdot xdotdot y ydot ydotdot z zdot
%                                   zdotdot]' in meters, meters/sec, and
%                                   meters/sec^2
%   t           (double array)      time for conversion: may have one entry
%                                   per column of ecef or may be a scalar 
%
% Expected Outputs:
%   ecef        (double array)      [x y z]'; same dimension and units as
%                                   data_eci
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Zachary Gorrell, Mark Levedahl
%   Date:  June 22, 2001
%   Classification:  UNCLASSIFIED
%   Revisions:  
%       Rev     Date        Change Author	Change
%       Rev_1   08/01/04    Bob Cheng       Use Environment Object to get
%                                           earth rotation
%       2       01/18/08    Paul Lewis      Move SABER physical contstants
%                                           to a global variable
%       3       02/23/09    Paul Lewis      Convert physical_constants to classdef
%       4       09/08/09    Paul Lewis      Use for position eci2ecef
%                                           calculation
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Check Arguments
if ~isnumeric(t)
    error('SABER:InvalidArgument', 'eci2ecef: t must be numeric') ;
end
nt = length(t) ;
if nt > 1 && nt ~= size(data_eci,2)
	error('SABER:InvalidArgument', ...
          'eci2ecef: t must be scalar or have one entry per column of data_eci') ;
end

%% global parameters
we = physical_constants.angular_rotation('rad/sec') ;

%% Rotation Angle
a = we * t(:)' ;
ca = cos(a) ;
sa = sin(a) ;

%% Set Output
ecef = zeros(size(data_eci)) ;

switch size (data_eci,1)                                             
case 3
    rxi = data_eci(1,:) ; ryi = data_eci(2,:) ;                                           % Position in x & y direction
    ecef(1,:) = ca.*rxi + sa.*ryi ;                                                      % x (ecef coordinates)
    ecef(2,:) = -sa.*rxi + ca.*ryi ;                                                     % y (ecef coordinates)
    ecef(3,:) = data_eci(3,:) ;                                                          % z (ecef coordinates)
    
case 6
    rxi = data_eci(1,:) ; ryi = data_eci(3,:) ;                                           % Position in x & y direction
    vxi = data_eci(2,:) ; vyi = data_eci(4,:) ;                                           % Velocity in x & y direction
    ecef(1,:) = ca.*rxi + sa.*ryi ;                                                      % x (ecef coordinates)
    ecef(2,:) = (vyi - we*rxi).*sa + (vxi + we*ryi).*ca ;                                % x_dot (ecef coordinates)
    ecef(3,:) = -sa.*rxi + ca.*ryi ;                                                     % y (ecef coordinates)
    ecef(4,:) = (-vxi - we*ryi).*sa + (vyi - we*rxi).*ca ;                               % y_dot (ecef coordinates)
    ecef(5:6,:) = data_eci(5:6,:) ;                                                      % z & z_dot (ecef coordinates)
    
case 9
    rxi = data_eci(1,:) ; ryi = data_eci(4,:) ;                                           % Position in x & y direction
    vxi = data_eci(2,:) ; vyi = data_eci(5,:) ;                                           % Velocity in x & y direction
    axi = data_eci(3,:) ; ayi = data_eci(6,:) ;                                           % Acceleration in x & y direction
    ecef(1,:) = ca.*rxi + sa.*ryi ;                                                      % x (ecef coordinates)
    ecef(2,:) = (vyi - we*rxi).*sa + (vxi + we*ryi).*ca ;                                % x_dot (ecef coordinates)
    ecef(3,:) = (ayi - we*(2*vxi + we*ryi)).*sa + (axi + we*(2*vyi - we*rxi)).*ca ;      % x_doubledot (ecef coordinates)
    ecef(4,:) = -sa.*rxi + ca.*ryi ;                                                     % y (ecef coordinates)
    ecef(5,:) = (-vxi - we*ryi).*sa + (vyi - we*rxi).*ca ;                               % y-dot (ecef coordinates)
    ecef(6,:) = (-axi + we*(-2*vyi + we*rxi)).*sa + (ayi - we*(2*vxi + we*ryi)).*ca ;    % y_doubledot (ecef coordinates)
    ecef(7:9,:) = data_eci(7:9,:) ;                                                      % z, z_dot, & z_doubledot (ecef coordinates)
    
otherwise
    error('SABER:InvalidArgument', ...
          'eci2ecef: incorrect state vector') ;
end
      
 