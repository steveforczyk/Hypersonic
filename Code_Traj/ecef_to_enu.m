%**************************************************************************
% [R] = ecef_to_enu(ECEFPos, <Dim>) - Tested
% Rotation matrix for a rotation from ECEF to ENU
% The transpose is the matrix for ENU to ECEF.
%**************************************************************************
%  Inputs	: ECEFPos (MxN, where M >= 3) ECEF position in meters
% 			:    that defines the origin of the ENU system.
% 			: Dim (optional, scalar) the desired dimension of R.
% 			:    Can be 3, 6, or 9.  Defaults to 3.
%  Outputs	: Returns the rotation matrix (Dim x Dim x N)
%**************************************************************************
% Classification: Unclassified
% Author		: Richard Barnes
% Copyright 2009 Richard Barnes
%**************************************************************************
function [R] = ecef_to_enu(ECEFPos, Dim, varargin)
%#eml
	% Perform error checking
	[M, N] = size(ECEFPos);
	if (M < 3 || N < 1)
		error('ECEFPos (%ux%u) must be at least 3xN, N > 1.', M, N);
    end
	
	% Initialization
	if (nargin < 2 || isempty(Dim) == true)
		Dim = 3;
    end
	
	Dim		= max(3, min(9, Dim(1)));
	R		= zeros(Dim, Dim, N);
	
	% Convert from ECEF to Lat/Lon/Alt and compute trig terms
	if (nargin >= 3)
		lla = varargin{1};
	else
		lla = to_latlonalt(ECEFPos(1:1:3, :));
    end
	
	slat	= sin(lla(1, :));
	clat	= cos(lla(1, :));
	
	slon	= sin(lla(2, :));
	clon	= cos(lla(2, :));
	
	% Form the rotation matrix
	R(1, 1, :) = -slon;
	R(1, 2, :) = +clon;
	
	R(2, 1, :) = -slat .* clon;
	R(2, 2, :) = -slat .* slon;
	R(2, 3, :) = +clat;
	
	R(3, 1, :) = +clat .* clon;
	R(3, 2, :) = +clat .* slon;
	R(3, 3, :) = +slat;
	
	if (Dim >= 6)
		R(4:1:6, 4:1:6, :) = R(1:1:3, 1:1:3, :);
		if (Dim >= 9)
			R(7:1:9, 7:1:9, :) = R(1:1:3, 1:1:3, :);
        end
    end
return;