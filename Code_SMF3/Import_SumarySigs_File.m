function Import_SumarySigs_File
% This routine will import a single SumarySigsFile. It is based
% on a similar routine in the OSC Tool V2.1
% Written: Stephen Forczyk
% Created: May 4,2019
% Revised: ----
global SumarySigsFile;
global SummarySigsTime SummarySigsAltKm SummarySigsSenAspect;
global SummarySigsBodAzim SummarySigsProjArea SummarySigsAvgTemp;
global SummarySigsEarthSA SummarySigsEarthBiStatAng SummarySigsSolarBiStatAng;
global SummarySigsInBand SummarySigsBandList;
global sumarysigspath;
global iloadedBandSigsFile iloadedSumarySigsFile;
global OSCInpFile;
global BBTable iloadedBandRatios;
global NumOSCBands OSCWaveLL OSCWaveUL;

% now import the data
    eval(['cd ' sumarysigspath(1:length(sumarysigspath)-1)]);
    ab=1;
    delimiterIn = ' ';
    headerlinesIn = 1;
    filetxt = file2cell(SumarySigsFile,false);
% There is 1 header record. Every column except the first has a period in
% it. Look at record 2 to establish how many columns of data and bands are
% present in the file
    line2txt=filetxt{2,1};
    [iper]=strfind(line2txt,'.');
    numper=length(iper);
    numpts=length(filetxt)-1;
    NumOSCBands=numper-9;
    SummarySigsTime=zeros(numpts,1);
    SummarySigsAltKm=zeros(numpts,1);
    SummarySigsSenAspect=zeros(numpts,1);
    SummarySigsBodAzim=zeros(numpts,1);
    SummarySigsProjArea=zeros(numpts,1);
    SummarySigsAvgTemp=zeros(numpts,1);
    SummarySigsEarthSA=zeros(numpts,1);
    SummarySigsEarthBiStatAng=zeros(numpts,1);
    SummarySigsSolarBiStatAng=zeros(numpts,1);
    SummarySigsInBand=zeros(numpts,NumOSCBands);
    dispstr=strcat('Start importing SumarySigsFile-',SumarySigsFile,'-which has-',...
        num2str(numpts),'-lines of data');
    disp(dispstr)
% now parse through the data-line by line
% The first ten columns on any line are fixed regardless of how many bands
% of data are present. The first data column is just a counter which is
% uneeded and wrong if the are more then 9999 points because of an OSC
% formatting problem. The scheme is to read in the data in columns 2
% through 10 to get the fixed metric data. All the remain data columns have
% band signature data
    for n=1:numpts
        linetxt=filetxt{1+n,1};
        [iper]=strfind(linetxt,'.');
        [ispace]=strfind(linetxt,' ');
        numper=length(iper);
        numspace=length(ispace);
        if(mod(n,500)==0)
            dispstr=strcat('Parsing line-',num2str(n),'-of-',...
            num2str(numpts),'-lines of data');
            disp(dispstr);
        end
% Now get the first word by grabbing everything from the last space before
% the first period to the first space after the first period
        ipernow=iper(1);
        [ifnd]=find(ispace>ipernow);
        ifndm1=ifnd-1;
        is=ispace(ifndm1);
        ie=ispace(ifnd(1));
        nowstr=linetxt(is:ie);
        time=str2num(nowstr);
        SummarySigsTime(n,1)=time;
% Now get the second word
        ipernow=iper(2);
        [ifnd]=find(ispace>ipernow);
        ifndm1=ifnd-1;
        is=ispace(ifndm1);
        ie=ispace(ifnd(1));
        nowstr=linetxt(is:ie);
        AltKm=str2num(nowstr);
        SummarySigsAltKm(n,1)=AltKm;
% Now get the third word
        ipernow=iper(3);
        [ifnd]=find(ispace>ipernow);
        ifndm1=ifnd-1;
        is=ispace(ifndm1);
        ie=ispace(ifnd(1));
        nowstr=linetxt(is:ie);
        SenAsp=str2num(nowstr);
        SummarySigsSenAspect(n,1)=SenAsp;
% Now get the fourth word
        ipernow=iper(4);
        [ifnd]=find(ispace>ipernow);
        ifndm1=ifnd-1;
        is=ispace(ifndm1);
        ie=ispace(ifnd(1));
        nowstr=linetxt(is:ie);
        BodyAzim=str2num(nowstr);
        SummarySigsBodAzim(n,1)=BodyAzim;
% Now get the fifth word
        ipernow=iper(5);
        [ifnd]=find(ispace>ipernow);
        ifndm1=ifnd-1;
        is=ispace(ifndm1);
        ie=ispace(ifnd(1));
        nowstr=linetxt(is:ie);
        ProjArea=str2num(nowstr);
        SummarySigsProjArea(n,1)=ProjArea;
% Now get the sixth word
        ipernow=iper(6);
        [ifnd]=find(ispace>ipernow);
        ifndm1=ifnd-1;
        is=ispace(ifndm1);
        ie=ispace(ifnd(1));
        nowstr=linetxt(is:ie);
        AvgTemp=str2num(nowstr);
        SummarySigsAvgTemp(n,1)=AvgTemp;
% Now get the seventh word
        ipernow=iper(7);
        [ifnd]=find(ispace>ipernow);
        ifndm1=ifnd-1;
        is=ispace(ifndm1);
        ie=ispace(ifnd(1));
        nowstr=linetxt(is:ie);
        EarthSA=str2num(nowstr);
        SummarySigsEarthSA(n,1)=EarthSA;
% Now get the eigth word
        ipernow=iper(8);
        [ifnd]=find(ispace>ipernow);
        ifndm1=ifnd-1;
        is=ispace(ifndm1);
        ie=ispace(ifnd(1));
        nowstr=linetxt(is:ie);
        EarthBiStat=str2num(nowstr);
        SummarySigsEarthBiStatAng(n,1)=EarthBiStat;
% Now get the ninth word
        ipernow=iper(9);
        [ifnd]=find(ispace>ipernow);
        ifndm1=ifnd-1;
        is=ispace(ifndm1);
        ie=ispace(ifnd(1));
        nowstr=linetxt(is:ie);
        SolarBiStat=str2num(nowstr);
        SummarySigsSolarBiStatAng(n,1)=SolarBiStat;
        for j=10:numper
            ipernow=iper(j);
            [ifnd]=find(ispace>ipernow);
            ifndm1=ifnd-1;
            is=ispace(ifndm1);
            ie=ispace(ifnd(1));
            nowstr=linetxt(is:ie);
            bandval=str2num(nowstr);
            SummarySigsInBand(n,j-9)=bandval;
        end
    end


    ab=7;
end