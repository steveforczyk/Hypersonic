function a=disturb(mu3,R,R3)
% Copyright Ashish Tewari (c) 2006
r=norm(R);
r3=norm(R3);
R23=R-R3;
r23=norm(R23);
fx=(r23/r3)^3-1;
a=-mu3*(R+fx*R3)/r23^3;