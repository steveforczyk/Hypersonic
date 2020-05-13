% Copyright Ashish Tewari (c) 2006
function [C,S]=stumpff(z,n)
C=0.5;
S=1/6;
for i=1:n
    C=C+(-1)^i*z^i/factorial(2*(i+1));
    S=S+(-1)^i*z^i/factorial(2*i+3);
end