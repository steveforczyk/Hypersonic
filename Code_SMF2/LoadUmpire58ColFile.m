function [Data]=LoadUmpire58ColFile(filename,nheaders)
% This function will load a 58 column data file created by
% Umpire. The primary difference is thT Umpire Writes the Yaw
% pitch and roll angle instead of the Euler angles

% Classification: Unclassified
fi = fopen(filename,'r');
if(~fi)
	error(['Cannot open ' filename]);
end

finfo = dir(filename);
for n=1:nheaders
    header=fgets(fi);
end

Data.Time = 		[];
Data.GroundRange = 	[];
Data.Altitude = 	[];
Data.AngleofAttack = 	[];
Data.FlightPathAng = 	[];
Data.PrecessionCone = 	[];
Data.Thrust = 		[];
Data.CGAxial = 		[];
Data.PositionECIx = 	[];
Data.PositionECIy = 	[];
Data.PositionECIz = 	[];
Data.PositionENUx = 	[];
Data.PositionENUy = 	[];
Data.PositionENUz = 	[];
Data.VelocityECIx = 	[];
Data.VelocityECIy = 	[];
Data.VelocityECIz = 	[];
Data.VelocityENUx = 	[];
Data.VelocityENUy = 	[];
Data.VelocityENUz = 	[];
Data.AccelECIx = 	[];
Data.AccelECIy = 	[];
Data.AccelECIz = 	[];
Data.AccelENUx = 	[];
Data.AccelENUy = 	[];
Data.AccelENUz = 	[];
Data.SensAccAxial = 	[];
Data.SensAccNormal = 	[];
Data.RollAngleECI = 	[];
Data.PitchAngleECI = 	[];
Data.YawAngleECI = 	[];
Data.RollAngleENU = 	[];
Data.PitchAngleENU = 	[];
Data.YawAngleENU = 	[];
Data.BodyRateAxial = 	[];
Data.BodyRateY = 	[];
Data.BodyRateZ = 	[];
Data.BallisticCoeff = 	[];
Data.Mass = 		[];
Data.CPPitchPlane = 	[];
Data.CPYawPlane = 	[];
Data.Airspeed = 	[];
Data.Ixx = 		[];
Data.Iyy = 		[];
Data.Izz = 		[];
Data.TimeOfLiftoff = 	[];
Data.MachNumber = 	[];
Data.SensedAccelY = 	[];
Data.SensedAccelZ = 	[];
Data.DynamicPress = 	[];
Data.PitchAoA = 	[];
Data.YawAoA = 		[];
Data.TimeLastState = 	[];
Data.TargetLat = 	[];
Data.TargetLong = 	[];
Data.DragCoeff = 	[];
Data.CMalphaSlope = 	[];
Data.TALO = 		[];

	
while(ftell(fi) < finfo.bytes)

	[data, cnt] = fscanf(fi, '%f ', 58);
	if (cnt ~= 58)
		error('Bad file read, didn''t get 58 items')
	end

	Data.Time(end+1) = 	     data(1); 
	Data.GroundRange(end+1) =    data(2);  
	Data.Altitude(end+1) = 	     data(3);  
	Data.AngleofAttack(end+1) =  data(4);  
	Data.FlightPathAng(end+1) =  data(5);  
	Data.PrecessionCone(end+1) = data(6); 
	Data.Thrust(end+1) = 	     data(7);  
	Data.CGAxial(end+1) = 	     data(8);  
	Data.PositionECIx(end+1) =   data(9);  
	Data.PositionECIy(end+1) =   data(10); 
	Data.PositionECIz(end+1) =   data(11);  
	Data.PositionENUx(end+1) =   data(12);  
	Data.PositionENUy(end+1) =   data(13);  
	Data.PositionENUz(end+1) =   data(14);  
	Data.VelocityECIx(end+1) =   data(15);  
	Data.VelocityECIy(end+1) =   data(16);  
	Data.VelocityECIz(end+1) =   data(17);  
	Data.VelocityENUx(end+1) =   data(18);  
	Data.VelocityENUy(end+1) =   data(19);  
	Data.VelocityENUz(end+1) =   data(20);  
	Data.AccelECIx(end+1) =      data(21);  
	Data.AccelECIy(end+1) =      data(22);  
	Data.AccelECIz(end+1) =      data(23);  
	Data.AccelENUx(end+1) =      data(24);  
	Data.AccelENUy(end+1) =      data(25);  
	Data.AccelENUz(end+1) =      data(26);  
	Data.SensAccAxial(end+1) =   data(27);  
	Data.SensAccNormal(end+1) =  data(28);  
	Data.RollAngleECI(end+1) =   data(29);  
	Data.PitchAngleECI(end+1) =  data(30);  
	Data.YawAngleECI(end+1) =    data(31);  
	Data.RollAngleENU(end+1) =   data(32);  
	Data.PitchAngleENU(end+1) =  data(33);  
	Data.YawAngleENU(end+1) =    data(34);  
	Data.BodyRateAxial(end+1) =  data(35);  
	Data.BodyRateY(end+1) =      data(36);  
	Data.BodyRateZ(end+1) =      data(37);  
	Data.BallisticCoeff(end+1) = data(38); 
	Data.Mass(end+1) = 	     data(39);        
	Data.CPPitchPlane(end+1) =   data(40);  
	Data.CPYawPlane(end+1) =     data(41);  
	Data.Airspeed(end+1) = 	     data(42);  
	Data.Ixx(end+1) = 	     data(43);        
	Data.Iyy(end+1) = 	     data(44);        
	Data.Izz(end+1) = 	     data(45);        
	Data.TimeOfLiftoff(end+1) =  data(46);  
	Data.MachNumber(end+1) =     data(47);  
	Data.SensedAccelY(end+1) =   data(48);  
	Data.SensedAccelZ(end+1) =   data(49);  
	Data.DynamicPress(end+1) =   data(50);  
	Data.PitchAoA(end+1) = 	     data(51);  
	Data.YawAoA(end+1) = 	     data(52);  
	Data.TimeLastState(end+1) =  data(53);  
	Data.TargetLat(end+1) =      data(54);  
	Data.TargetLong(end+1) =     data(55);  
	Data.DragCoeff(end+1) =      data(56);
	Data.CMalphaSlope(end+1) =   data(57);
	Data.TALO(end+1) = 	     data(58);        

end	


fclose(fi);
fields = fieldnames(Data);
for i = 1:length(fields)
    Data.(fields{i}) = Data.(fields{i})';
end

return
