% example1.m
% AUTHOR:           Robyn Woollands (robyn.woollands@gmail.com)
% DATE WRITTEN:     June, 2014
% LAST MODIFIED:    May, 2016
% AFFILIATION:      Department of Aerospace Engineering, Texas A & M University, College Station, TX
%
% DESCRIPTION:      Example test case for solving Lambert's problem

clear
close all
clc

%% Example 1
r0  = [9500      0        0];    % Initial Position (km)
rf  = [5978     14244     0];    % Final Position (km)
tof = 5.1750e3;                  % Time-of-flight (sec)
tol = 1e-10;                     % Tolerance (non-dimensional)
fig = 1;                         % Plot figures (YES = 1, NO = 0)

keplerian_lambert_solver(r0,rf,tof,tol,fig);

%% Example 2
r0  = [9500      0        0];    % Initial Position (km)
rf  = [6175     -12823    0];    % Final Position (km)
tof = 1.5525e4;                  % Time-of-flight (sec)
tol = 1e-10;                     % Tolerance (non-dimensional)
fig = 1;                         % Plot figures (YES = 1, NO = 0)

keplerian_lambert_solver(r0,rf,tof,tol,fig);