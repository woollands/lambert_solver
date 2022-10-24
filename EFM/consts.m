% consts.m
% AUTHOR:           Robyn Woollands (robyn.woollands@gmail.com)
% DATE WRITTEN:     May, 2016
% LAST MODIFIED:    May, 2016
% AFFILIATION:      Department of Aerospace Engineering, Texas A & M University, College Station, TX
%
% DESCRIPTION:      Load constants for Kelperian Lambert solver

mu      = 3.986004418e5;     % Gravitational Const
Re      = 6378.137;          % Earth radius (km)

% Canonical Units
muCan   = 1;
DU      = Re;
TU      = sqrt(DU^3 / mu);
VU      = DU/TU;