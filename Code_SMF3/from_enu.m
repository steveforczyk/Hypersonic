%**************************************************************************
% [ECEF] = from_enu(ECEFReference, ENU) - Tested
% Converts from ENU to ECEF coordinate systems.
% Handles position/velocity/acceleration vectors
%**************************************************************************
% Inputs	: ECEFReference (MxN, where M is 3, 6, or 9) ECEF vector
%			:    that defines the origin of the ENU system.
%			: ENU (MxN, where M is 3, 6, or 9) ENU vector
%			:    to be converted to the ECEF system.
% Outputs	: Returns the ECEF vectors (MxN, where M is 3, 6, or 9)
%**************************************************************************
% Classification: Unclassified
% Author		: Richard Barnes
% Copyright 2009 Richard Barnes
%**************************************************************************
function [ECEF] = from_enu(ECEFReference, ENU, varargin)
%#eml
	% Perform error checking
	[K, L] = size(ECEFReference);
	[M, N] = size(ENU);
	
	if (K < 3 || K > 9 || L < N)
		error('ECEFReference must be KxN, where K is 3, 6, or 9.');
	elseif (M < 3 || M > 9|| N < 1)
		error('ENU must be MxN, where M is 3, 6, or 9.');
	end;
	
	% Initialization
	ndim = min(9, floor(M / 3) * 3);
	rdim = min(ndim, floor(K / 3) * 3);
	
	% Compute transformation matrices
	R = ecef_to_enu(ECEFReference, ndim, varargin{:});
	if (N == 1)
		R = R';
	else
		R = permute(R, [2, 1, 3]);
	end;
	
	% Perform the coordinate transformation
	topo = zeros(ndim, N);
	for k = 1:1:N,
		topo(:, k) = R(:, :, k) * ENU(:, k);
	end;
	
	ECEF = topo;
	for k = 1:3:rdim,
		range = (k - 1) + (1:1:3);
		ECEF(range, :) = ECEF(range, :) + ECEFReference(range, :);
	end;
return;