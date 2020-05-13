function [QXx] = EulerToDCM(phi,theta,psi)
% This routine will compute the direction cosing matrix from the
% series of three Euler rotations. 
% angles are phi=about precession angle
%            theta=nutation angle
%            psi = spin angle
% Source: Orbital Mechanics for Engineering Students 2nd edition
% page 538-540
% checks out Ok May 2,2019
% Created By: Stephen Forczyk
% Written: May 4,2019
% Revised:--------
% Classification: Unclassified

QXx=zeros(3,3);
QXx(1,1)=-sind(phi)*cosd(theta)*sind(psi)+ cosd(phi)*cosd(psi);% ok
QXx(1,2)=cosd(phi)*cosd(theta)*sind(psi)+ sind(phi)*cosd(psi); % ok
QXx(1,3)=sind(theta)*sind(psi); %ok

QXx(2,1)=-sind(phi)*cosd(theta)*cosd(psi)-cosd(phi)*sind(psi);% ok
QXx(2,2)=cosd(phi)*cosd(theta)*cosd(psi)-sind(phi)*sind(psi);%ok
QXx(2,3)=sind(theta)*cosd(psi);% ok

QXx(3,1)=sind(phi)*sind(theta);%ok
QXx(3,2)=-cosd(phi)*sind(theta);%ok
QXx(3,3)=cosd(theta);% ok
end

