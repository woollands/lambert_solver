% initialize.m
% AUTHOR:           Robyn Woollands (robyn.woollands@gmail.com)
% DATE WRITTEN:     May, 2016
% LAST MODIFIED:    May, 2016
% AFFILIATION:      Department of Aerospace Engineering, Texas A & M University, College Station, TX
%
% DESCRIPTION:      Initial setup computations for lambert's problem

function [r1,r2,R1,R2,v0A,v0B,c,s,a_m,theta,t_des,N] = initialize(xx,kk,TIME,DepOrbit,ArrOrbit)

% Time of flight
t_des   = TIME(kk);

% Initial Position (Orbit A)
r0A     = DepOrbit(xx,1:3);
v0A     = DepOrbit(xx,4:6);

% Final Position (Orbit B)
r0B     = ArrOrbit((xx-1)+kk,1:3);
v0B     = ArrOrbit((xx-1)+kk,4:6);

r1      = r0A; % DU
r2      = r0B; % DU

% Magnitude
R1      = sqrt(r1*r1');
R2      = sqrt(r2*r2');

c       = norm(r2 - r1);               % Chord
s       = (R1 + R2 + c)/2;             % Semiperimeter
a_m     = s/2;                         % Minimum energy semimajor axis
theta   = acos(r1*r2'/(R1*R2));        % Angle between position vectors 

% Number of revs
N       = 0;

return