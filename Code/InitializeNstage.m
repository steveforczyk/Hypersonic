% This script will initialize the function nstage
% from Ashish Tewarki Atmospheric and SpaceFlight Dynamics P 203
% Set up is for a 3 stage Missile N=3;
% beta is the non dimension isp for the first stage
% first stage has isp of 290
% second stage has isp of 290
% third stage has isp of 455
% sigma is the payload ratio for each stage
%alpha is the payload ratio for each stage
% 1 stage payload ratio is 1 2nd stage is 1.2 second stage
% 3rd stage payload ratio is 1.65
% total delta v needed is 13 km/sec 
% total propellant mass =1000 kg
icase=2;
if(icase==1)
    N=3;
    ml=1000;
    beta=[1;1;455/290];
    sigma=0.07*[1;1;1];
    alpha=[1;1.2;0.65];
    vf=13000/(9.81*290);
    p=Nstage(vf,beta,sigma,alpha);% First stage payload ratio
% get the total payload ratio
    lambdaTot=(p^N)*alpha(2,1)*alpha(3,1);
    m01=ml/lambdaTot;% Total rocket mass
    m02=p*m01;% second stage mass
    lambda2=(p^1)*alpha(2,1);
    m03=lambda2*m02;% third stage mass
    mp3=(m03-ml)*(1-sigma(3,1));
    mp2=(m02-m03)*(1-sigma(2,1));
    mp1=(m01-m02)*(1-sigma(1,1));
    total_propellant=mp1+mp2+mp3;
    ab=1;
elseif(icase==2)
    N=2;
    ml=350;
    beta=[1;1.75];
    sigma=[0.07;0.05];
    alpha=[1;0.15];
    vf=9500/(9.81*200);
    p=Nstage(vf,beta,sigma,alpha);% First stage payload ratio
    lambdaTot=(p^N)*alpha(2,1);
    ab=1;
end