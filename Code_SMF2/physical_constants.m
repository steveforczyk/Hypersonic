% This class defines the physical constants used by SABER.
%
% References:
%   Bate, Roger etc, "Fundamentals of Astrodynamics", (c)1997, Dover Books
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Author: Bob Cheng
%	Date: May 12th, 2004
%   Classification:  UNCLASSIFIED
%   Revisions:
%       Rev     Date        Change Author	Change     
%       1       04/21/05    Paul Lewis      Add mean earth radius
%                                           Add simulation run radius
%                                           Restructure constructor and
%                                           set methods
%       2       08/02/05    Paul Lewis      Add Earth's eccentricity
%       3       12/20/05    Paul Lewis      Convert toggles to boolean
%       4       02/03/06    Paul Lewis      Change constants to reflect
%                                           ECCA specifications from WGS84 
%       5       09/01/06    Paul Lewis      Make the simulation earth
%                                           radius a global variable 
%       6       05/23/07    Paul Lewis      Add scenario sample time features 
%       7       07/31/07    Paul Lewis      Replace ITiM and ITiM++ with SABER
%       8       01/16/08    Paul Lewis      Converted envrionment to
%                                           physical_constants,
%                                           constants_simulation, and
%                                           atmospheric_conditions
%       9       01/07/09    Paul Lewis      Add sidereal_day
%       10      02/20/09    Paul Lewis      Convert to classdef
%       11      11/30/11    Paul Lewis      SCR 167 - correct Planck and
%                                           Boltzman constants
%       12      06/21/12    Paul Lewis      SCR 233 - add WGS84 earth polar
%                                           radius
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef physical_constants

    properties (Constant = true, GetAccess = private)
        % These constants are private so we can allow the user to access
        % them and request a specific units adjustment at the same time.
        % This is accomplished with the static functions of this class.
        % We prepended a C_ to each name becuase we want to publicly access
        % these constants with the unmodified name.
        
        % mean value of the radius of the Earth in meters at any angle
        % from the Earth's center. (WGS84)
		C_earth_mean_radius = 6371008.7714
		
        % Earth's average equatorial radius in meters. (WGS84)
		C_earth_equatorial_radius = 6378137.0
		
        % Earth's average polar radius in meters. (WGS84)
		C_earth_polar_radius = 66356752.3142
		
        % effective Earth radius including refraction in meters. (Allnutt)
		C_earth_effective_radius = 8500000
    
        % Earth's gravitation parameter in unit of km^3/sec^2. (WGS84) 
		C_gravitational_parameter = 3.986004418*10^5
		
        % rate of Earth's angular rotation in radian/second. (WGS84)
		C_angular_rotation = 7.292115 * 10^-5 
		
        % speed of light in meters/second.
		C_speed_of_light = 299792458
    end
    
    properties (Constant = true, GetAccess = public)
        % These constants do not have unit adjustments, so they do not need
        % adjusted names or static functions for acccess.
        
        % measure of deviation in Earth's orbit from a perfect circle.
        % SABER assumes a circular orbit.
        % earth_eccentricity = 0.081819221456 
		earth_eccentricity = 0.0
           
        % length of sidereal day in mean solar seconds.
        sidereal_day = 86164.09054 
        
        % Boltzmanns' Constant in J/K. (NIST Reference on Constants,
        % Units, and Uncertainty)
		Boltzmann = 1.3806488E-23
        
        % Planck's Constant in J*s.  (NIST Reference on Constants,
        % Units, and Uncertainty)
		Planck = 6.62606957E-34
        
        % Stefan Boltzmann's constant in J*K^-4*m^-2*s^-1.
		sig = 5.6705E-8
end

    methods (Static = true, Access = public)
        display
        o_object_descriptor = set_object_descriptor(o_object_descriptor)
    end

    methods (Static = true, Sealed = true)
        function value = earth_mean_radius(units)
            value = physical_constants.C_earth_mean_radius ;
            if exist('units', 'var')
                value = unit_conversion(value, 'meters', units) ;
            end
        end
        function value = earth_equatorial_radius(units)
            value = physical_constants.C_earth_equatorial_radius ;
            if exist('units', 'var')
                value = unit_conversion(value, 'meters', units) ;
            end
        end
        function value = earth_polar_radius(units)
            value = physical_constants.C_earth_polar_radius ;
            if exist('units', 'var')
                value = unit_conversion(value, 'meters', units) ;
            end
        end
        function value = earth_effective_radius(units)
            value = physical_constants.C_earth_effective_radius ;
            if exist('units', 'var')
                value = unit_conversion(value, 'meters', units) ;
            end
        end
        function value = gravitational_parameter(units)
            value = physical_constants.C_gravitational_parameter ;
            if exist('units', 'var')
                value = unit_conversion(value, 'km^3/sec^2', units) ;
            end
        end
        function value = angular_rotation(units)
            value = physical_constants.C_angular_rotation ;
            if exist('units', 'var')
                value = unit_conversion(value, 'rad/sec', units) ;
            end
        end
        function value = speed_of_light(units)
            value = physical_constants.C_speed_of_light ;
            if exist('units', 'var')
                value = unit_conversion(value, 'm/sec', units) ;
            end
        end
        function value = earth_radius(units)
            value = physical_constants.C_earth_mean_radius ;
            if exist('units', 'var')
                value = unit_conversion(value, 'meters', units) ;
            end
        end
    end
end

