function [ihit] = DetermineImpactPoliticalRegion(n,FMaxLat,FMinLat,FMaxLon,FMinLon,imapType)
% This routine will establish if an impact point is inside a polygon
% determined by a political entities boundary region
% Written By: Stephen Forczyk
% Created: April 24,2020
% Revised: ------
% Classification: Unclassified
global MapLatMin MapLatMax MapLonMin MapLonMax;
global MapShortFileList;
global MapLatMin180 MapLatMax180;
global MapLonMin360 MapLonMax360;
global ExcelDiagFile Results Results2;
iuse=0;
ipass=0;
ipass1=0;
ipass2=0;
ipass3=0;
ipass4=0;
% To deal with the longitude problem make sure all the longitudes
% run from 0 to 360 degrees
if(MapLonMin<0)
    MapLonMin360=MapLonMin+360;
else
    MapLonMin360=MapLonMin;
end
if(MapLonMax<0)
    MapLonMax360=MapLonMax+360;
else
    MapLonMax360=MapLonMax;
end
if(FMaxLon<0)
    FMaxLon360=FMaxLon+360;
else
    FMaxLon360=FMaxLon;
end
if(FMinLon<0)
    FMinLon360=FMinLon+360;
else
    FMinLon360=FMinLon;
end
% if(FMaxLon360<=FMinLon360)
%     FMaxLon360=360;
%     FMinLon360=0;
% end
if(FMaxLon360<=FMinLon360) % SMF Trial Fix Sept 13,2016
    FMaxLon360=FMaxLon360+360;
end
% Corner 1 Max Lat,Max Lon
ipass1=zeros(4,1);
for m=1:4
    ilatpass=0;
    ilonpass=0;
    if(m==1)
        xval=FMaxLon360;
        yval=FMaxLat;
    elseif(m==2)
        xval=FMaxLon360;
        yval=FMinLat;
    elseif(m==3)
        xval=FMinLon360;
        yval=FMinLat;
    else
        xval=FMinLon360;
        yval=FMaxLat;
    end
    if((yval>=MapLatMin) && (yval<=MapLatMax))
        ilatpass=1;
    end
    if((xval>=MapLonMin360) && (xval<=MapLonMax360))
        ilonpass=1;
    end
    ipass1(m,1)=ilatpass*ilonpass;
end
% This is intended for the case where the Country is larger than the Map
% window
ipass2=zeros(4,1);
for m=1:4
    ilatpass=0;
    ilonpass=0;
    if(m==1)
        xval=MapLonMax360;
        yval=MapLatMax;
    elseif(m==2)
        xval=MapLonMax360;
        yval=MapLatMin;
    elseif(m==3)
        xval=MapLonMin360;
        yval=MapLatMin;
    else
        xval=MapLonMin360;
        yval=MapLatMax;
    end
    if((yval>=FMinLat) && (yval<=FMaxLat))
        ilatpass=1;
    end
    if((xval>=FMinLon360) && (xval<=FMaxLon360))
        ilonpass=1;
    end
    ipass2(m,1)=ilatpass*ilonpass;
end
iuse1=ipass1(1,1)+ipass1(2,1)+ipass1(3,1)+ipass1(4,1);
iuse2=ipass2(1,1)+ipass2(2,1)+ipass2(3,1)+ipass2(4,1);
iuse=iuse1+iuse2;
if(iuse>1)
    iuse=1;
end

mname=MapShortFileList(n,:);
if(imapType==1)
    Results{1+n,1}=n;
    Results{1+n,2}=mname;
    Results{1+n,3}=MapLatMin;
    Results{1+n,4}=MapLatMax;
    Results{1+n,5}=MapLonMin;
    Results{1+n,6}=MapLonMax;
    Results{1+n,7}=FMinLat;
    Results{1+n,8}=FMaxLat;
    Results{1+n,9}=FMinLon;
    Results{1+n,10}=FMaxLon;
    Results{1+n,11}=ipass1(1,1);
    Results{1+n,12}=ipass1(2,1);
    Results{1+n,13}=ipass1(3,1);
    Results{1+n,14}=ipass1(4,1);
    Results{1+n,15}=ipass2(1,1);
    Results{1+n,16}=ipass2(2,1);
    Results{1+n,17}=ipass2(3,1);
    Results{1+n,18}=ipass2(4,1);
    Results{1+n,19}=iuse;
elseif(imapType==2)
    Results2{1+n,1}=n;
    Results2{1+n,2}=mname;
    Results2{1+n,3}=MapLatMin;
    Results2{1+n,4}=MapLatMax;
    Results2{1+n,5}=MapLonMin;
    Results2{1+n,6}=MapLonMax;
    Results2{1+n,7}=FMinLat;
    Results2{1+n,8}=FMaxLat;
    Results2{1+n,9}=FMinLon;
    Results2{1+n,10}=FMaxLon;
    Results2{1+n,11}=ipass1(1,1);
    Results2{1+n,12}=ipass1(2,1);
    Results2{1+n,13}=ipass1(3,1);
    Results2{1+n,14}=ipass1(4,1);
    Results2{1+n,15}=ipass2(1,1);
    Results2{1+n,16}=ipass2(2,1);
    Results2{1+n,17}=ipass2(3,1);
    Results2{1+n,18}=ipass2(4,1);
    Results2{1+n,19}=iuse;
end

