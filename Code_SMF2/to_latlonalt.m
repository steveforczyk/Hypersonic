%**************************************************************************
% [LatLonAlt] = to_latlonalt(ECEFPos) - Tested
% Converts ECEF positions into Latitude/Longitude/Altitudes
%*********************************************************************
% Inputs	: ECEFPos is a 3xN matrix of ECEF positions in meters
% Outputs	: Returns the Lat/Lon/Alt positions (3xN)
%			:    The units are meters/radians/radians
%**************************************************************************
% Classification: Unclassified
% Credit		: Fundamentals of Astrodynamics, 2nd edition
%				: Davide Vallado
% Author		: Richard Barnes
% Copyright 2009 Richard Barnes
%**************************************************************************
function [LatLonAlt] = to_latlonalt(ECEFPos)
%#eml
	% Global Variables
	global Earth;
	if (isempty(Earth) == true)
		constants();
	end;
	
	% Local Constants
	AltTol		= 1.0e-10;
	LLA_Tol		= 1.0e-9;
	LLA_MaxItr	= 100;
	
	% Perform error checking
	[M, N] = size(ECEFPos);
	if (M < 3 || N < 1)
		error('ECEFPos must be at least 3xN.');
	end;
	
	major = Earth.MajorAxis;
	minor = Earth.MinorAxis;
	
	% Handle spherical Earth
	if (major == minor)
		AltLonLat		= to_spherical(ECEFPos(1:1:3, :));
		AltLonLat(1, :)	= AltLonLat(1, :) - major;
		LatLonAlt		= AltLonLat([3, 2, 1], :);
	% Handle ellipsoidal Earth
	else
		% Initialization
		ecc		= Earth.Eccentricity;
%		Rxy		= sqrt(sum((ECEFPos(1:1:2, :)) .^ 2, 1));
		Rxy		= hypot(ECEFPos(1, :), ECEFPos(2, :));
		
		% Compute an initial guess for latitude
		lat		= atan2(ECEFPos(3, :), Rxy);
		lat_old	= lat;
		lerror	= realmax() * ones(N, 1);
		
		% Perform the conversion
		itr		= 0;
		index	= find(lerror > LLA_Tol);
		
		while (isempty(index) == false && itr < LLA_MaxItr)
			slat		= sin(lat(index));
			sterm		= ecc .* slat;
			eterm		= (1 - sterm) .* (1 + sterm);
			lterm		= sterm .* ecc;
			C			= major ./ (sqrt(eterm) + eps);
			
			lat(index)	= atan2(ECEFPos(3, index) + (C .* lterm), Rxy(index));
			
			lerror		= abs(lat - lat_old);
			lat_old		= lat;
			index		= find(lerror > LLA_Tol);
		end;
		
		cterm			= ecc .* sin(lat);
		C				= major ./ (sqrt((1 - cterm) .* (1 + cterm)) + eps);
		
		LatLonAlt		= zeros(3, N);
		LatLonAlt(1, :)	= lat;
		LatLonAlt(2, :)	= atan2(ECEFPos(2, :), ECEFPos(1, :));
		LatLonAlt(3, :)	= (Rxy ./ (cos(lat) + eps)) - C;
	end;
	
	% Check for Latitude near 90 degrees for altitude problems
	singular = find(is_angle_singular(LatLonAlt(1, :)));
	if (isempty(singular) == false)
		Z = ECEFPos(3, singular);
		b = minor * sign(Z);
		LatLonAlt(3, singular) = (Z - b) .* sin(LatLonAlt(1, singular));
	end;
	
	% Force altitude to zero if within the computer's precision
	LatLonAlt(3, -AltTol <= LatLonAlt(3, :) & LatLonAlt(3, :) <= +AltTol) = 0;
return;