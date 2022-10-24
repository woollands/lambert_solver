% EFM_example1.m
% AUTHOR:           Robyn Woollands (robyn.woollands@gmail.com)
% DATE WRITTEN:     May, 2016
% LAST MODIFIED:    May, 2016
% AFFILIATION:      Department of Aerospace Engineering, Texas A & M University, College Station, TX
%
% DESCRIPTION:      User input for generating Keplerian extremal field maps between two orbits.

clearvars -except filename
close all

consts;                      % Load Constants

setplot = 0;                 % Output figures: NO = 0 (recommended) & YES = 1 (for debugging).

tol     = 1e-10;             % Set tolerance

% Departure Orbit Elements
DepA    = 10000;             % Semimajoe Axis (km)
DepE    = 0.05;              % Eccentricity
DepI    = 0*pi/180;          % Inclination (rad)
DepOm   = 0*pi/180;          % Right Ascension of Ascending Node (rad)
DepW    = 0*pi/180;          % Argument of Perigee (rad)
DepM0   = 0*pi/180;          % Mean Anomaly (rad)

% Arrival Orbit Elements
ArrA    = 15000;             % Semimajor Axis (km)
ArrE    = 0.1;               % Eccentricity
ArrI    = 0*pi/180;          % Inclination (rad)
ArrOm   = 0*pi/180;          % Right Ascension of Ascending Node (rad)
ArrW    = 0*pi/180;          % Argument of Perigee (rad)
ArrM0   = 0*pi/180;          % Mean Anomaly (rad)

% Extremal Field Map Specifics
DimH    = 6;                 % Horizontal dimension of EFM (Number of departure orbit periods)
DimV    = 6;                 % Vertical dimension of EFM (Number of departure orbit periods)
EFMres  = 150;               % EFM resolution. Number of points along x axis.


