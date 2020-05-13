% Copyright Ashish Tewari (c) 2006
function qpp=quatrot(q,qp)
qpp=q*[qp(4) qp(3) -qp(2) qp(1);
     -qp(3) qp(4) qp(1) qp(2);
     qp(2) -qp(1) qp(4) qp(3);
     -qp(1) -qp(2) -qp(3) qp(4)]';