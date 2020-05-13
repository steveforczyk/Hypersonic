% This code was provided by Dan Watts.
function eci_data=lla2eci(lla_data)

% lla_data=[Time,Lat,Lon,Alt,Vmag,Elev,Heading]
% Time[seconds] from ECI = ECR
% Lat[rad]
% Lon[rad]
% Alt[m]
% VMag[m/s]
% Elevation[rad]
% Heading[rad]
% Vmag, Elev, and Heading are optional
% eci_data=[Time, X, Y, Z, X_dot, Y_dot, Z_dot]
% X-Z[M]
% X_dot-Z_dot[M/s]
% X_dot, Y_dot, and Z_dot are optional




%Omega - WGS84 Earth rotation rate [rad/s]
Omega = .7292115147E-4;
%Requatorial RPolar[m] WGS84 values
REquatorial = 6378137.0;
RPolar = 6356750.5;

Time=lla_data(:,1);
Lat=lla_data(:,2);
Lon=lla_data(:,3);
Alt=lla_data(:,4);


Rot_ang = Omega * Time;
%Rot_angle - rotation angle of earth fsince T=0
SLat = atan((RPolar/REquatorial)^2 * tan(Lat));
%SLat - Surface spherical latidude [radians]
%Lon_eci - ECI Longitude [radians]
Lon_eci = Lon + Rot_ang;

Z = RPolar.*sin(SLat) + Alt.*sin(Lat);
R = REquatorial.*cos(SLat) + Alt.*cos(Lat);
X = R.*cos(Lon_eci);
Y = R.*sin(Lon_eci);
% keyboard
eci_data=[Time,X,Y,Z];

if size(lla_data,2)>4
    Vmag=lla_data(:,5);
    Elev=lla_data(:,6);
    Heading=lla_data(:,7);

    U = [cos(Lat).*cos(Lon_eci) cos(Lat).*sin(Lon_eci) sin(Lat)];
    E = [-sin(Lon_eci), cos(Lon_eci), zeros(size(Lon_eci,1),1)];
    N=cross(U,E);

    X_dot = Vmag.*(cos(Elev).*cos(Heading).*N(:,1) + ...
        cos(Elev).*sin(Heading).*E(:,1) + ...
        sin(Elev).*U(:,1)) - R .* Omega .* sin(Lon_eci);
    Y_dot = Vmag.*(cos(Elev).*cos(Heading).*N(:,2) + ...
        cos(Elev).*sin(Heading).*E(:,2) + ...
        sin(Elev).*U(:,2)) + R .* Omega .* cos(Lon_eci);
    Z_dot = Vmag.*(cos(Elev).*cos(Heading).*N(:,3) + ...
        cos(Elev).*sin(Heading).*E(:,3) + ...
        sin(Elev).*U(:,3));

    eci_data=[eci_data,X_dot,Y_dot,Z_dot];
end

