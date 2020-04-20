clear 
close all
clc

%% Load variables
load variables_for_step3
load plant
load controller

nc = nn;
nu = 2;

delta=1e-10;
Vs=1e0*eye(nu,nu);
U=delta*inv(Vs);
Sai=[Q*Ao'+Ao*Q,Bqo*U+Q*Cyo',Bw,Q*Czo';U*Bqo'+Cyo*Q,Dyqo*U+U*Dyqo'-2*U,Dyw,U*Dzqo';Bw',Dyw',-gama*eye(nw,nw),Dzw';Czo*Q,Dzqo*U,Dzw,-gama*eye(nz,nz)];
H=[H1,H2,zeros(naw+nv,nw),H3];
G=[G1*Q,G2*U,zeros(naw+nu,nw+nz)];

%% LMI Definition
setlmis([]);

GAMA = lmivar(2,[naw+nv naw+nu]);

%LMI terms
lmiterm([1 1 1 GAMA],H',G,'s'); % LMI #1:
lmiterm([1 1 1 0],Sai); % LMI #1:

LMISYS = getlmis;

%% Finding Feasible Solution 
% [~,x] = feasp(LMISYS,[0 1000 5e5 0 1]);
[~,x] = feasp(LMISYS);
GAMA = dec2mat(LMISYS,x,1);
GAMA1 = GAMA(1:naw,1:naw);
GAMA2 = GAMA(1:naw,naw+1:end);
GAMA3 = GAMA(naw+1:end,1:naw);
GAMA4 = GAMA(naw+1:end,naw+1:end);
% eig(GAMA1)
GAMA0 = GAMA;
save GAMA GAMA1 GAMA2 GAMA3 GAMA4
GAMA10 = GAMA1;
GAMA20 = GAMA2;
GAMA30 = GAMA3;
GAMA40 = GAMA4;
save GAMA0 GAMA10 GAMA20 GAMA30 GAMA40
% step(ss(GAMA1,GAMA2,GAMA3,GAMA4))