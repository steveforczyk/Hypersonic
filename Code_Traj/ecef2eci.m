function eci = ecef2eci(ecef, t)
% ECEF2ECI converts ecef points to eci
%
% Expected Inputs:
%	ecef	(double array)      3 x N, 6 x N, or 9 x N array, one column
%                               per point
%                               [x y z]' in meters
%                                 OR
%                               [x xdot y ydot z zdot]' in meters, and
%                               meters/sec 
%                                 OR
%                               [x xdot xdotdot y ydot ydotdot z zdot
%                               zdotdot]' in meters, meters/sec, and
%                               meters/sec^2
%   t       (double array)      time for conversion: may have one entry
%                               per column of ecef or may be a scalar 
%
% Expected Outputs:
%   eci     (double array)      [x y z]'; same dimension and units as ecef
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Mark Levedahl
%   Date:  ?
%   Classification:  UNCLASSIFIED
%   Revisions:  
%       Rev     Date        Change Author	Change
%       Rev_1   08/01/04    Bob Cheng       Use Environment Object to get
%                                           earth rotation
%       2       01/18/08    Paul Lewis      Move SABER physical contstants
%                                           to a global variable
%       3       02/23/09    Paul Lewis      Convert physical_constants to classdef
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Check arguments
nt = length(t) ;
if nt > 1 && nt ~= size(ecef, 2)
	error('SABER:InvalidArgument', ...
          'ecef2eci: t must be scalar or have one entry per column of ecef') ;
end

%% global parameters
we = physical_constants.angular_rotation('rad/sec') ;

%% rotation angle
a = we * t(:)' ;
ca = cos(a) ;
sa = sin(a) ;

%% set output
eci = zeros(size(ecef)) ;

switch size(ecef,1)
case 3
	rxe = ecef(1,:) ; rye = ecef(2,:) ;
	eci(1,:) = ca.*rxe - sa.*rye ;
	eci(2,:) = sa.*rxe + ca.*rye ;
	eci(3,:) = ecef(3,:) ;

case 6
	rxe = ecef(1,:) ; rye = ecef(3,:) ;
	vxe = ecef(2,:) ; vye = ecef(4,:) ;
	eci(1,:) = ca.*rxe - sa.*rye ;
	eci(2,:) = (-vye - we*rxe).*sa + (vxe - we*rye).*ca;
	eci(3,:) = sa.*rxe + ca.*rye ;
	eci(4,:) = (vxe - we*rye).*sa + (vye + we*rxe).*ca;
	eci(5:6,:) = ecef(5:6,:) ;

case 9
	rxe = ecef(1,:) ; rye = ecef(4,:) ;
	vxe = ecef(2,:) ; vye = ecef(5,:) ;
	axe = ecef(3,:) ; aye = ecef(6,:) ;
	eci(1,:) = ca.*rxe - sa.*rye;
	eci(2,:) = (-vye - we*rxe).*sa + (vxe - we*rye).*ca ;
	eci(3,:) = (-aye - we*(2*vxe - we*rye)).*sa + (axe - we*(2*vye + we*rxe)).*ca ;
	eci(4,:) = sa.*rxe + ca.*rye ;
	eci(5,:) = (vxe - we*rye).*sa + (vye + we*rxe).*ca ;
	eci(6,:) = (axe - we*(2*vye + we*rxe)).*sa + (aye + we*(2*vxe - we*rye)).*ca ;
	eci(7:9,:) = ecef(7:9,:) ;

otherwise
	error('SABER:InvalidArgument', ...
          'ecef2eci: incorrect state vector') ;
end
