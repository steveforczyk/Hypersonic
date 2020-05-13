function [alpha,beta,gamma] = dcm_to_euler(Q)
% Taken from Appendix D of Orbital Mechanics For Engineering Students 2nd
% Edition
% Checks Ok SMF May 4,2019
 alpha=atan2d_0_360(Q(3,1),-Q(3,2));
 beta=acosd(Q(3,3));
 gamma=atan2d_0_360(Q(1,3),Q(2,3));
end

