% t_min_energy.m
% AUTHOR:           Robyn Woollands (robyn.woollands@gmail.com)
% DATE WRITTEN:     May, 2016
% LAST MODIFIED:    May, 2016
% AFFILIATION:      Department of Aerospace Engineering, Texas A & M University, College Station, TX
%
% DESCRIPTION:      Computes the time corresponding to the minimum energy transfer

function [t_m,alpha_m,beta_m] = t_min_energy(s,c,a_m,theta)

global muCan

alpha_m = 2*asin(sqrt(s/(2*a_m)));      % Eq. 5.26
beta_m  = 2*asin(sqrt((s-c)/(2*a_m)));  % Eq. 5.27
if theta >= pi && theta < 2*pi
    beta_m = -beta_m;                   % Eq. 5.31b
end

% Compute time corresponding to min energy transfer
t_m = sqrt(a_m^3/muCan)*(alpha_m - beta_m - (sin(alpha_m) - sin(beta_m))); % Eq. 5.42 (with N=0)

return