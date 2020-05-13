function [numMDAonmap]=CutDownMDAListRev2(maxCode)
% The purpose of this routine is to take the loaded MDA facilities list
% and create a smaller list that just contains those cities that will
% actually be mapped. Derived from Rev1 version to eliminate output to 
% GUI message box
% Written By: Stephen Forczyk
% Created: April 8,2020
% Revised: 
% Classification: Unclassified
global MDAName MDACountry MDAType MDALat MDALon;
global MDATypeCode ;
global MDANameMap MDACountryMap MDATypeMap MDALatMap MDALonMap;
global MDATypeCodeMap;
global MapLatMin MapLatMax MapLonMin MapLonMax;
global MapLonMin360 MapLonMax360;


numMDAonlist=length(MDALat);
numMDAonmap=0;
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
if(MapLonMax360<MapLonMin360)
    holdval=MapLonMax360;
    MapLonMax360=MapLonMin360;
    MapLonMin360=holdval;
end
% On the first pass through just count the number of facilities that will make
% it onto the map
for n=1:numMDAonlist
    nowMDALat=MDALat(n,1);
    nowMDALon=MDALon(n,1);
    nowCode=MDATypeCode(n,1);
    if(nowMDALon<0)
        nowMDALon=nowMDALon+360;
    end
    nowMDAName=MDAName(n,:);
    ipass=0;
    if((nowMDALat>=MapLatMin) && (nowMDALat<=MapLatMax))
        ipass1=1;
    else
        ipass1=0;
    end
    if((nowMDALon>=MapLonMin360) && (nowMDALon<=MapLonMax360))
        ipass2=1;
    else
        ipass2=0;
    end
    ipass3=1;
    if(nowCode>maxCode)
        ipass3=0;
    end
    ipass=ipass1*ipass2*ipass3;
    if(ipass>0)
        numMDAonmap=numMDAonmap+1;
    end
end
% Now allocate space as needed
ind=0;
if(numMDAonmap>0)
    MDALatMap=zeros(numMDAonmap,1);
    MDALonMap=zeros(numMDAonmap,1);
    MDATypeCodeMap=zeros(numMDAonmap,1);
    for n=1:numMDAonlist
        nowMDALat=MDALat(n,1);
        nowMDALon=MDALon(n,1);
        nowCode=MDATypeCode(n,:);
        nowCountry=MDACountry(n,:);
        nowType=MDAType(n,:);
        if(nowMDALon<0)
            nowMDALon=nowMDALon+360;
        end
        nowMDAName=MDAName(n,:);
        ipass=0;
        if((nowMDALat>=MapLatMin) && (nowMDALat<=MapLatMax))
            ipass1=1;
        else
            ipass1=0;
        end
        if((nowMDALon>=MapLonMin360) && (nowMDALon<=MapLonMax360))
            ipass2=1;
        else
            ipass2=0;
        end
        ipass3=1;
        if(nowCode>maxCode)
            ipass3=0;
        end
        ipass=ipass1*ipass2*ipass3;
        if(ipass>0)
            ind=ind+1;
            MDALatMap(ind,1)=nowMDALat;
            MDALonMap(ind,1)=nowMDALon;
            MDATypeCodeMap(ind,1)=nowCode;
            if(ind==1)
                MDANameMap=nowMDAName;
                MDACountryMap=nowCountry;
                MDATypeMap=nowType;
            else
                MDANameMap=strvcat(MDANameMap,nowMDAName);
                MDACountryMap=strvcat(MDACountryMap,nowCountry);
                MDATypeMap=strvcat(MDATypeMap,nowType);
            end
        end
   
    end
else
    MDALatMap=[];
    MDALonMap=[];
    MDATypeCodeMap=[];
    MDANameMap=[];
    MDACountryMap=[];
    MDATypeMap=[];
end
    dispstr=strcat('MDA list had-',num2str(numMDAonlist,6),'-but only-',num2str(numMDAonmap,6),...
        '-are on the map frame');
    disp(dispstr);
end

