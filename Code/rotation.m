% Copyright Ashish Tewari (c) 2006
function C=rotation(i,Om,w)
L1=cos(Om)*cos(w)-sin(Om)*sin(w)*cos(i);
L2=-cos(Om)*sin(w)-sin(Om)*cos(w)*cos(i);
L3=sin(Om)*sin(i);
M1=sin(Om)*cos(w)+cos(Om)*sin(w)*cos(i);
M2=-sin(Om)*sin(w)+cos(Om)*cos(w)*cos(i);
M3=-cos(Om)*sin(i);
N1=sin(w)*sin(i);
N2=cos(w)*sin(i);
N3=cos(i);
C=[L1 L2 L3;M1 M2 M3;N1 N2 N3];