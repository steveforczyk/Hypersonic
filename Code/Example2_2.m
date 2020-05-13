% This script will be for Example 2.2 P15


iprime=[0.1;0.2;sqrt(1-.01-.04)];
jprime=[-.1;-0.9726095077;sqrt(1-.01-.9726095077^2)];
kprime=cross(iprime,jprime);

dispstr=strcat('iprime=',num2str(iprime,8));
disp(dispstr)

dotp=dot(iprime,jprime);

dispstr=strcat('The dot product of iprime & jprime=',num2str(dotp));
disp(dispstr)

% Compute the components of the rotation vector
i=[1;0;0];
j=[0;1;0];
k=[0;0;1];
C=[dot(iprime,i),dot(iprime,j),dot(iprime,k);...
    dot(jprime,i),dot(jprime,j),dot(jprime,k);...
    dot(kprime,i),dot(kprime,j),dot(kprime,k)];

disp('The components of the rotation vector follow')

C
detC=det(C);
dispstr=strcat('The determinant of C=',num2str(detC,6));
disp(dispstr)

% Now get the inverse of C

Cinv=inv(C)


disp('Show the product of the rotation matrix and its inverse')
C*Cinv

% Now calcuate the Euler angle and Euler axis for this rotation matrix

[c,D]=eig(C);

disp('Show the eigenvectors')

c

disp('Now show the eigenvalues')

D

% Calculate the rotation angle

phi=acos(0.5*(trace(C)-1));
phideg=(180/pi)*phi;

dispstr=strcat('The rotation angle is=',num2str(phi,6),'-rads and-',...
    num2str(phideg,6),'-degrees');
disp(dispstr)