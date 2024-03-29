% velocity.m
% AUTHOR:           Robyn Woollands (robyn.woollands@gmail.com)
% DATE WRITTEN:     May, 2016
% LAST MODIFIED:    May, 2016
% AFFILIATION:      Department of Aerospace Engineering, Texas A & M University, College Station, TX
%
% DESCRIPTION:      Solves for initial velocity of the transfer orbit

function [v1,v2,delV,delVD,delVA] = velocity(r0A,r0B,v0A,v0B,R1,R2,c,alpha,beta,a,t_curr)

global muCan

u1 = r0A/R1;                         % Eq. 5.35
u2 = r0B/R2;
uc = (r0B - r0A)/c;

% Clean up (miniscule img part)
a      = real(a);
t_curr = real(t_curr);
alpha  = real(alpha);
beta   = real(beta);

A = sqrt(muCan/4/a)*cot(alpha/2);   % Eq. 5.37a
B = sqrt(muCan/4/a)*cot(beta/2);    % Eq. 5.37b

v1 = (B+A)*uc + (B-A)*u1;           % Eq. 5.36
v2 = (B+A)*uc - (B-A)*u2;

% delV = 0.5*(dot(v1-v0A,v1-v0A) + dot(v2-v0B,v2-v0B)); % Delta V cost
delV = norm(v1-v0A) + norm(v2-v0B); % Delta V cost
delVD = norm(v1-v0A); % Departure
delVA = norm(v2-v0B); % Arrival

return