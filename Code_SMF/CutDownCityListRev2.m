function [numcitiesonmap]=CutDownCityListRev2(CityLat,CityLon,CityName,CityPop,CityRank,maxRank)
% The purpose of this routine is to take the loaded city list
% and create a smaller list that just contains those cities that will
% actually be mapped based on being inside the map frame
% and having a rank no greater than the desired limit
% Derived from Rev1 function but handles reference removed as this
% routine does not send data out to a gui message box
% Written By: Stephen Forczyk
% Created: April 8,2020
% Revised: ------
% Classification: Unclassified

global MapLatMin MapLatMax MapLonMin MapLonMax;
global CityLatMap CityLonMap CityNameMap CityPoPMap CityRankMap;
global MapLonMin360 MapLonMax360;
global numcitiesmap;

numcitiesonmap=0;
numcitiesonlist=length(CityLat);
numcitiesmap=0;
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
% On the first pass through just count the number of cities that will make
% it onto the map
numcitiesmap=0;
for n=1:numcitiesonlist
    nowCityLat=CityLat(n,1);
    nowCityLon=CityLon(n,1);
    nowCityRank=CityRank(n,1);
    if(nowCityLon<0)
        nowCityLon=nowCityLon+360;
    end
    nowCityName=CityName(n,:);
    if(n>11700)
        ab=1;
    end
    ipass=0;
    if((nowCityLat>=MapLatMin) && (nowCityLat<=MapLatMax))
        ipass1=1;
    else
        ipass1=0;
    end
    if((nowCityLon>=MapLonMin360) && (nowCityLon<=MapLonMax360))
        ipass2=1;
    else
        ipass2=0;
    end
    if(nowCityRank<=maxRank)
        ipass3=1;
    else
        ipass3=0;
    end
    ipass=ipass1*ipass2*ipass3;
    if(ipass>0)
        numcitiesmap=numcitiesmap+1;
    end
end
% Now allocate space as needed
ind=0;
if(numcitiesmap>0)
    CityLatMap=zeros(numcitiesmap,1);
    CityLonMap=zeros(numcitiesmap,1);
    CityPoPMap=zeros(numcitiesmap,1);
    CityRankMap=zeros(numcitiesmap,1);
    for n=1:numcitiesonlist
        nowCityLat=CityLat(n,1);
        nowCityLon=CityLon(n,1);
        nowCityRank=CityRank(n,1);
        if(nowCityLon<0)
            nowCityLon=nowCityLon+360;
        end
        nowCityName=CityName(n,:);
        nowCityPoP=CityPop(n,1);
        nowCityRank=CityRank(n,1);
        ipass=0;
        if((nowCityLat>=MapLatMin) && (nowCityLat<=MapLatMax))
            ipass1=1;
        else
            ipass1=0;
        end
        if((nowCityLon>=MapLonMin360) && (nowCityLon<=MapLonMax360))
            ipass2=1;
        else
            ipass2=0;
        end
        if(nowCityRank<=maxRank)
            ipass3=1;
        else
            ipass3=0;
        end
        ipass=ipass1*ipass2*ipass3;
        if(ipass>0)
            ind=ind+1;
            CityLatMap(ind,1)=nowCityLat;
            CityLonMap(ind,1)=nowCityLon;
            CityPoPMap(ind,1)=nowCityPoP;
            CityRankMap(ind,1)=nowCityRank;
            if(ind==1)
                CityNameMap=nowCityName;
            else
                CityNameMap=strvcat(CityNameMap,nowCityName);
            end
        end
   
    end
else
    CityLatMap=[];
    CityLonMap=[];
    CityPoPMap=[];
    CityRankMap=[];
    CityNameMap=[];
end
    dispstr=strcat('City list had-',num2str(numcitiesonlist,7),'-but only-',num2str(numcitiesmap,7),...
        '-are on the map frame and meet the rank limit');
    disp(dispstr);
    numcitiesonmap=ind;
end

