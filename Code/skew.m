% Copyright Ashish Tewari (c) 2006
function S=skew(v)
S=[0 -v(3) v(2);v(3) 0 -v(1);-v(2) v(1) 0];