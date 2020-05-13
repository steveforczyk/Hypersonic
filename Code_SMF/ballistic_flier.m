function [state,covar] = ballistic_flier(state0,tspan,tol)
% -------------------------------------------------------------------------
% Author:   Jorge O'Farrill
% Usage:    [state,covar] = ballistic_flier(state0,tspan,tol)
% Purpose:  create ballistic trajectory by propagating initial state,
%           state0 over a time span tspan using ode45 to solver J2 EOMs for
%           oblate spheroidal earth
%
% Outputs:  state  - ECI state 6xN, 6x1 vector at each time tag
%           covar  - ECI covaraince 6x6xN, 6x6 at each time tag
%
% Inputs:   state0 - Initial ECI state ([x y z vel_x vel_y vel_z]')
%           tspan  - time tags of time span for propagation (1xN)
%           tol    - tolerance for ode solver ~ 1e-6 sufficient optional
% !optional! if you want to propagate a covariance
%           state0 - Initial ECI state and covariance in the form
%           [[x y z vel_x vel_y vel_z]' reshape(covariance,36,1)]!optional!
% -------------------------------------------------------------------------
global cunits
state0 = state0(:);
tspan=tspan(:);
cunits=0;
if norm(state0(1:3))<40 % in canonical units moon orbits at about r=40 
    cunits=1;
end

if exist('tol','var')==0 % default value works well
    tol=1e-6;
end

if numel(state0)==6 % if no covariance provided
    state0(7:42)=reshape(eye(6),36,1);
end

options = odeset('RelTol',tol); % options for ode solver
[t,st]  = ode45(@J2EOM,tspan,state0,options); % solve EOMs defined by J2EOM
% in order to produce ECI state st. t will be the same as tspan provided
% numel(tspan)>2
state = st(:,1:6)';% state components
cov   = st(:,7:42)'; % covariance components
covar=zeros(6,6,numel(t));
for it=1:numel(t)
    covar(:,:,it) = reshape(cov(:,it),6,6);
end

return

function [dxu] = J2EOM(t,xu)
global cunits % this is really slow maybe you can find a better way to pass this
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EOMs in J2 gravity field
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% mks units the usual m s kg units
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    mu=398600411800000;
    re=6378137;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%canonical units maybe more numerically stable
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if cunits==1
    mu=1;
    re=1;
end

RE=re;
%x(1:6)=xu(1:6);
n=6;
r=sqrt(xu(1)^2 + xu(2)^2 + xu(3)^2);
r2i=r^-2;
ri2=r2i;
r3i=r^-3;
ri3=r3i;
r4i=r^-4;
ri4=r4i;
r5i=r^-5;
ri5=r5i;
l3=(5*r2i*xu(3)^2 - 1);
ll3=(3 - 5*r2i*xu(3)^2);
j2=0.0010826269; % if j2 = 0 spherical earth is recovered
J2=j2;
%j2=0;
phi=-(mu*r3i)*(1 - (3/2)*j2*(re^2)*r2i*l3);
lamda=-(mu*r3i)*(1 + (3/2)*j2*(re^3)*r3i*ll3);

%%% J2 EOMs
dxu(1)=xu(4);
dxu(2)=xu(5);
dxu(3)=xu(6);
dxu(4)=phi*xu(1);
dxu(5)=phi*xu(2);
dxu(6)=lamda*xu(3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%now we must solve for the sensitivity matrix u(t) to propagate covariance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%u=eye(6);
F = zeros(6);%F = del(f)/del x_i
x=xu(1);
y=xu(2);
z=xu(3);

F(1,4) = 1.0;
F(2,5) = 1.0;
F(3,6) = 1.0;

F(4,1) = -mu*ri3*(1 - 3*x^2*ri2 + 1.5*J2*RE^2*ri2*(1-5*ri2*(x^2+z^2-7*x^2*z^2*ri2)));
F(4,2) = 3*mu*x*y*ri5*(1 + 2.5*J2*RE^2*ri2*(1-7*z^2*ri2));
F(4,3) = 3*mu*x*z*ri5*(1 + 2.5*J2*RE^2*ri2*(3-7*z^2*ri2));

F(5,1) = 3*mu*x*y*ri5*(1 + 2.5*J2*RE^2*ri2*(1-7*z^2*ri2));
F(5,2) = -mu*ri3*(1 - 3*y^2*ri2 + 1.5*J2*RE^2*ri2*(1-5*ri2*(y^2+z^2-7*y^2*z^2*ri2)));
F(5,3) = 3*mu*y*z*ri5*(1 + 2.5*J2*RE^2*ri2*(3-7*z^2*ri2));

F(6,1) = 3*mu*x*z*ri5*(1 + J2*RE^3*ri3*(9-20*z^2*ri2));
F(6,2) = 3*mu*y*z*ri5*(1 + J2*RE^3*ri3*(9-20*z^2*ri2));
F(6,3) = -mu*ri3*(1 - 3*z^2*ri2 + 1.5*J2*RE^3*ri3*(3-33*z^2*ri2+40*z^4*ri4));

u=reshape(xu(n+1:n*(n+1),1),n,n);
du=F*u + u*F'; % equation for propagating covariance

dx= [dxu(1),dxu(2),dxu(3),dxu(4),dxu(5),dxu(6)];
du=reshape(du,1,36);
dxu=[dx du]';
return