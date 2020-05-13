function lla=eci2llaRev6(eci)
%eci should be in form of:
%[Epoch_Seconds X(meters) Y(meters) Z(meters)]
%LLA will be in form of:
%[Ephoch_Seconds Geod.Lat(Deg) Long.(Deg) Alt(meters)]
%code Developed and Tested by Eric Broyles, Photon Research Associates

ecf=eci2ecfRev6(eci);
lla=ecf2llaRev6(ecf);
