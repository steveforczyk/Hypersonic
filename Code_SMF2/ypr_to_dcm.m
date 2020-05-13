function [QXx] = ypr_to_dcm(yaw,pitch,roll)
% Get the direction cosine matrix from the yaw pitch and roll angles
% Source: Orbital Mechanics for Engineering Students 2nd Ed P550
%
QXx=zeros(3,3);
QXx(1,1)=cosd(yaw)*cosd(pitch);
QXx(1,2)=sind(yaw)*cosd(pitch);
QXx(1,3)=-sind(pitch);
QXx(2,1)=cosd(yaw)*sind(pitch)*sind(roll)-sind(yaw)*cosd(roll);
QXx(2,2)=sind(yaw)*sind(pitch)*sind(roll)+cosd(yaw)*cosd(roll);
QXx(2,3)=cosd(pitch)*sind(roll);
QXx(3,1)=cosd(yaw)*sind(pitch)*cosd(roll)+sind(yaw)*sind(roll);
QXx(3,2)=sind(yaw)*sind(pitch)*cosd(roll)-cosd(yaw)*sind(roll);
QXx(3,3)=cosd(pitch)*cosd(roll);
end

