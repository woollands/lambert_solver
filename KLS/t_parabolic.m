% t_parabolic.m
% AUTHOR:           Robyn Woollands (robyn.woollands@gmail.com)
% DATE WRITTEN:     May, 2016
% LAST MODIFIED:    May, 2016
% AFFILIATION:      Department of Aerospace Engineering, Texas A & M University, College Station, TX
%
% DESCRIPTION:      Computes the time of flights for a parabolic orbit

function [t_p,parab] = t_parabolic(s,c,theta,t_des)

global muCan

% Calculate t_parabolic
t_p = sqrt(2)/3*(s^1.5 -sign(sin(theta))*(s-c)^1.5)/sqrt(muCan);   % Eq. 5.34

if t_des < t_p
    parab = 1;
else
    parab = 0;
end

return