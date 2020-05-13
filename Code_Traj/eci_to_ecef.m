%**************************************************************************
% [R] = eci_to_ecef(Date, Time, Timestamp, <Dim>)
% Rotation matrix for a rotation from ECI to ECEF.
% The inverse is the ECEF to ECI rotation matrix.
%**************************************************************************
% Inputs	: Date (empty or 3 elements) containing the current date
%			:    Date(1) is the month (January = 1)
%			:    Date(2) is the day
%			:    Date(3) is the year
%			:    If empty matrix, then ignores all IERS effects
%			: Time (empty or 3 elements) containing the reference time
%			:    Time(1) is the hour (midnight = 0, noon = 12)
%			:    Time(2) is the minutes
%			:    Time(3) is the seconds
%			:    If empty matrix, then ignores all IERS effects
%			: Timestamp (N elements) containing the elapsed time
%			:    in seconds since the reference time.
%			: Dim (optional, scalar) the desired dimension of R.
%			:    Can be 3, 6, or 9.  Defaults to 3.
% Outputs	: R (KxKxN, K is 3, 6, or 9) are the rotation matrices
%**************************************************************************
% Limits	: All IERS effects are ignored
%**************************************************************************
% Classification: Unclassified
% Credit		: Fundamentals of Astrodynamics, David Vallado
%				: IAU 2000 ICRF, GCRF, and ITRF standard
% Author		: Richard Barnes
% Copyright 2009 Richard Barnes
%**************************************************************************
function [R] = eci_to_ecef(Date, Time, Timestamp, Dim)
%#eml
	% Global variables
	global Earth;
	if (isempty(Earth) == true)
		constants();
	end;
	
	% Perform error checking
	if (isempty(Date) == false && numel(Date) ~= 3)
		error('Date must be an empty matrix or 3 elements.');
	elseif (isempty(Time) == false && numel(Time) ~= 3)
		error('Time must be an empty matrix or 3 elements.');
	end;
	
	% Initialization
	if (nargin < 4 || isempty(Dim) == true)
		Dim = 3;
	end;
	
	N			= numel(Timestamp);
	Timestamp	= Timestamp(:);
	Dim			= max(3, min(9, Dim(1)));
	
	% Determine if IERS data is to be used
	use_iers	=							...
		isempty(Date) == false			&&	...
		isempty(Time) == false			&&	...
		isempty(Earth.IERS) == false;
	
	% Handle the case of non-rotating Earth
	if (Earth.AngularVelocity == 0)
		R = zeros(Dim, Dim, N);
		for k = 1:1:Dim,
			R(k, k, :) = 1;
		end;
	% Handle the case of a rotating Earth
	else
		% Compute the rotation matrices for the Earth's spin
		angle = +Timestamp * Earth.AngularVelocity;
		RSpin = dcm_z(angle);
		
		% Handle the case of no IERS effects
		if (use_iers == false)
			% Form the total rotation matrix
			R = zeros(Dim, Dim, N);
			for k = 1:1:N,
				R(1:1:3, 1:1:3, k) = RSpin(:, :, k);
			end;
			
			if (Dim >= 6)
				% Form Earth's rotational velocity cross product as a matrix
				omega = -cross_to_matrix([0; 0; abs(Earth.AngularVelocity)]);
				
				% Form the velocity components
				for k = 1:1:N,
					R(4:1:6, 1:1:3, k) = omega * RSpin(:, :, k);
					R(4:1:6, 4:1:6, k) = RSpin(:, :, k);
				end;
				
				% Form the acceleration components
				if (Dim >= 9)
					for k = 1:1:N,
						R(7:1:9, 1:1:3, k) = omega * omega * RSpin(:, :, k);
						R(7:1:9, 4:1:6, k) = 2 * omega * RSpin(:, :, k);
						R(7:1:9, 7:1:9, k) = RSpin(:, :, k);
					end;
				end;
			end;
		% Handle the case of IERS effects
		else
			% Retrieve the IERS data
			% IERS = iers_retrieve(Date, Earth.IERS);
			
			% Compute the rotation for the Earth's polar wobble
			RWobble = eye(3)';
			
			% Compute the rotation for the Earth's precession/nutation
			% Use inverse of RWobble due to using ECI epoch-of-day
			RPN = RWobble';
			
			% Combine the spin and precession/nutation matrices
			RSPN = zeros(size(RSpin));
			for k = 1:1:N,
				RSPN(:, :, k) = RSpin(:, :, k) * RPN;
			end;
			
			% Form the total rotation matrix
			R = zeros(Dim, Dim, N);
			for k = 1:1:N,
				R(1:1:3, 1:1:3, k) = RWobble * RSPN(:, :, k);
			end;
			
			if (Dim >= 6)
				% Form Earth's rotational velocity cross product as a matrix
				omega = -cross_to_matrix([0; 0; abs(Earth.AngularVelocity)]);
				
				% Form the velocity components
				for k = 1:1:N,
					R(4:1:6, 1:1:3, k) = RWobble * omega * RSPN(:, :, k);
					R(4:1:6, 4:1:6, k) = RWobble * RSPN(:, :, k);
				end;
				
				% Form the acceleration components
				if (Dim >= 9)
					for k = 1:1:N,
						R(7:1:9, 1:1:3, k) = RWobble * omega * omega * RSPN(:, :, k);
						R(7:1:9, 4:1:6, k) = RWobble * 2 * omega * RSPN(:, :, k);
						R(7:1:9, 7:1:8, k) = RWobble * RSPN(:, :, k);
					end;
				end;
			end;
		end;
	end;
return;