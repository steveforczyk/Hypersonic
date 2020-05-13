function converted_value = unit_conversion(old_value, from_units, to_units)
% UNIT_CONVERSION converts old_value from from_units to to_units.
%
% Expected Inputs:
%	old_value           (number matrix)
%	from_units          (string)
%	to_units            (string)
%
% Expected Outputs:
%   converted_value     (number)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Paul Lewis
%   Date:  September 20, 2005
%   Revisions:  
%       Rev     Date        Change Author	Change  
%       1       01/29/08    Paul Lewis      Remove spaces, add km
%       2       03/20/09    Paul Lewis      Allow for conversion of numeric
%                                           arrays
%       3       02/12/10    Paul Lewis      Add knots to m/sec
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% remove blank characters
from_units = strrep(from_units, ' ', '') ;
to_units = strrep(to_units, ' ', '') ;

if isempty(from_units) || isempty(to_units)
    converted_value = old_value ;
elseif strcmp(from_units, to_units)
    converted_value = old_value ;
else
    switch from_units
        case {'kilometers', 'km'}
            switch to_units
                case 'kilometers'
                    converted_value = old_value ;
                case 'meters'
                    converted_value = old_value .* 1000 ;
                otherwise
                    unknown_conversion_warning(from_units, to_units) ;
                    converted_value = old_value ;
            end

        case 'meters'
            switch to_units
                case {'kilometers', 'km'}
                    converted_value = old_value ./ 1000 ;
                case 'meters'
                    converted_value = old_value ;
                otherwise
                    unknown_conversion_warning(from_units, to_units) ;
                    converted_value = old_value ;
            end

        case 'km^3/sec^2'
            switch to_units
                case 'km^3/sec^2'
                    converted_value = old_value ;
                case 'm^3/sec^2'
                    converted_value = old_value .* 1000^3 ;
                otherwise
                    unknown_conversion_warning(from_units, to_units) ;
                    converted_value = old_value ;
            end

        case 'm^3/sec^2'
            switch to_units
                case 'km^3/sec^2'
                    converted_value = old_value ./ 1000^3 ;
                case 'm^3/sec^2'
                    converted_value = old_value ;
                otherwise
                    unknown_conversion_warning(from_units, to_units) ;
                    converted_value = old_value ;
            end

        case 'km/sec'
            switch to_units
                case 'km/sec'
                    converted_value = old_value ;
                case 'm/sec'
                    converted_value = old_value .* 1000 ;
                otherwise
                    unknown_conversion_warning(from_units, to_units) ;
                    converted_value = old_value ;
            end

        case 'knots'
            switch to_units
                case 'knots'
                    converted_value = old_value ;
                case 'm/sec'
                    converted_value = old_value .* 0.15444 ;
                otherwise
                    unknown_conversion_warning(from_units, to_units) ;
                    converted_value = old_value ;
            end

        case {'m/s', 'm/sec'}
            switch to_units
                case 'km/sec'
                    converted_value = old_value ./ 1000 ;
                case 'm/sec'
                    converted_value = old_value ;
                case 'm/s'
                    converted_value = old_value ;
                otherwise
                    unknown_conversion_warning(from_units, to_units) ;
                    converted_value = old_value ;
            end

        case 'deg/sec'
            switch to_units
                case 'deg/sec'
                    converted_value = old_value ;
                case 'rad/sec'
                    converted_value = old_value .* (pi / 180) ;
                otherwise
                    unknown_conversion_warning(from_units, to_units) ;
                    converted_value = old_value ;
            end

        case 'rad/sec'
            switch to_units
                case 'deg/sec'
                    converted_value = old_value .* (180 / pi) ;
                case 'rad/sec'
                    converted_value = old_value ;
                otherwise
                    unknown_conversion_warning(from_units, to_units) ;
                    converted_value = old_value ;
            end

        case 'degrees'
            switch to_units
                case 'degrees'
                    converted_value = old_value ;
                case 'radians'
                    converted_value = old_value .* (pi / 180) ;
                otherwise
                    unknown_conversion_warning(from_units, to_units) ;
                    converted_value = old_value ;
            end

        case 'radians'
            switch to_units
                case 'degrees'
                    converted_value = old_value .* (180 / pi) ;
                case 'radians'
                    converted_value = old_value ;
                otherwise
                    unknown_conversion_warning(from_units, to_units) ;
                    converted_value = old_value ;
            end

        otherwise
            unknown_conversion_warning(from_units, to_units) ;
            converted_value = old_value ;
    end     % switch from_units
end     % if empty





function unknown_conversion_warning(from_units, to_units)
% UNKNOWN_CONVERSION_WARNING prints an information message for
% an attempt to convert from_units to to_units when there is not a
% procedure available for doing the conversion.
%
% Expected Inputs:
%	from_units          (string)
%	to_units            (string)
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Paul Lewis
%   Date:  September 20, 2005
%   Classification:  UNCLASSIFIED
%   Revisions:  
%       Rev     Date        Change Author	Change                          
%       1       08/01/07    Paul Lewis      Replace ITiM and ITiM++ with SABER
%       2       10/03/08    Todd Hunter-Gilbert  change warnings to saber_rattle 
%       3       02/25/09    Paul Lewis      Convert simulation_constants to
%                                           classdef 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

detail_text = sprintf('Can not convert %s to %s', from_units, to_units) ;
SABER_warning.rattle('INFORMATION', ...
                     'SABER:InvalidArgument', ...
                     'unit_conversion', ...
                     detail_text) ;                
