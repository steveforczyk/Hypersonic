function [Coord] = EarthCoord(Lat,Lon,H)
% Based on equation 5.56 on page 283 Orbital Mech For Engineering Student
% Second Edition
%
Re=6378;
Re=6378137;
f=0.003353;
f=1/298.257222101;

Paren1=(Re/(sqrt(1-(2*f-f^2)*sind(Lat))^2)+H);
Paren2=(Re*(1-f)^2)/(sqrt(1-(2*f-f^2)*sind(Lat))^2)+H;
Coord(1,1)=Paren1*cosd(Lat)*(cosd(Lon));
Coord(2,1)=Paren1*cosd(Lat)*(sind(Lon));
Coord(3,1)=Paren2*sind(Lat);
end

