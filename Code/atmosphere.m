% Copyright Ashish Tewari (c) 2006
function Y = atmosphere(h, vel, CL)
R = 287; 
go = 9.806; 
Na = 6.0220978e23; 
sigma = 3.65e-10; 
S = 110.4;  
Mo = 28.964; 
To = 288.15; 
Po = 1.01325e5; 
re = 6378.14e3; 
Beta = 1.458e-6; 
gamma = 1.405; 
B = 2/re;
layers = 21;
Z = 1e3*[0.00; 11.0191; 20.0631; 32.1619; 47.3501; 51.4125; 
    71.8020; 86.00; 100.00; 110.00; 120.00; 150.00; 160.00; 170.00; 190.00;
    230.00; 300.00; 400.00; 500.00; 600.00; 700.00; 2000.00];
T = [To; 216.65; 216.65; 228.65; 270.65; 270.65; 214.65; 186.946;
    210.65; 260.65; 360.65; 960.65; 1110.60; 1210.65; 1350.65; 1550.65;
    1830.65; 2160.65; 2420.65; 2590.65; 2700.00; 2700.0];
M = [Mo; 28.964; 28.964; 28.964; 28.964; 28.964; 28.962; 28.962; 28.880;
    28.560; 28.070; 26.920; 26.660; 26.500; 25.850; 24.690;
    22.660; 19.940; 17.940; 16.840; 16.170; 16.17];
LR = [-6.5e-3; 0; 1e-3; 2.8e-3; 0; -2.8e-3; -2e-3;
    1.693e-3; 5.00e-3; 1e-2; 2e-2; 1.5e-2; 1e-2; 7e-3; 5e-3; 4e-3;
    3.3e-3; 2.6e-3; 1.7e-3; 1.1e-3; 0];
rho0 = Po/(R*To);
P(1) = Po;
T(1) = To;
rho(1) = rho0;
for i = 1:layers
    if ~(LR(i) == 0)
        C1 = 1 + B*( T(i)/LR(i) - Z(i) );
        C2 = C1*go/(R*LR(i));
        C3 = T(i+1)/T(i);
        C4 = C3^(-C2);
        C5 = exp( go*B*(Z(i+1)-Z(i))/(R*LR(i)) );
        P(i + 1) = P(i)*C4*C5;
        C7 = C2 + 1;
        rho(i + 1) = rho(i)*C5*C3^(-C7);
    else
        C8 = -go*(Z(i+1)-Z(i))*(1 - B*(Z(i + 1) + Z(i))/2)/(R*T(i));
        P(i+1) = P(i)*exp(C8);
        rho(i+1) = rho(i)*exp(C8);
    end
end

for i = 1:21
    if h < Z(i+1)
        if ~(LR(i)== 0)
            C1 = 1 + B*( T(i)/LR(i) - Z(i) );
            TM = T(i) + LR(i)*(h - Z(i));
            C2 = C1*go/(R*LR(i));
            C3 = TM/T(i);
            C4 = C3^(-C2);
            C5 = exp( B*go*(h - Z(i))/(R*LR(i)) );
            PR = P(i)*C4*C5;
            C7 = C2 + 1;
            rhoE = C5*rho(i)*C3^(-C7);
        else
            TM = T(i);
            C8 = -go*(h - Z(i))*(1 - (h + Z(i))*B/2)/(R*T(i));
            PR = P(i)*exp(C8);
            rhoE = rho(i)*exp(C8);
        end      
        MOL = M(i) + ( M(i+1)-M(i) )*( h - Z(i) )/( Z(i+1) - Z(i) );
        TM = MOL*TM/Mo;
        asound = sqrt(gamma*R*TM); 
        MU = Beta*TM^1.5/(TM + S); 
        KT = 2.64638e-3*TM^1.5/(TM + 245.4*10^(-12/TM));
        Vm = sqrt(8*R*TM/pi);
        m = MOL*1e-3/Na;
        n = rhoE/m;
        F = sqrt(2)*pi*n*sigma^2*Vm;
        L = Vm/F; 
        Mach = vel/asound; 
        T0 = TM*(1 + (gamma - 1)*Mach^2/2);
        MU0 = Beta*T0^1.5/(T0 + S);
        RE0 = rhoE*vel*CL/MU0;
        RE = rhoE*vel*CL/MU; 
        Kn = L/CL; 
        Kno = 1.25*sqrt(gamma)*Mach/RE0;
        if Kn >= 10
            d = 1;
        elseif Kn <= 0.01 
            d = 2;
        else         
            d = 3;
        end
        Y = [TM; rhoE; Mach; Kn; asound; d; PR; MU; RE];
        return;
    end
end