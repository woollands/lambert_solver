% feasiblity.m
% AUTHOR:           Robyn Woollands (robyn.woollands@gmail.com)
% DATE WRITTEN:     May, 2016
% LAST MODIFIED:    May, 2016
% AFFILIATION:      Department of Aerospace Engineering, Texas A & M University, College Station, TX
%
% DESCRIPTION:      Checks if the solution is physically feasible

function [Ecol,EscVel,FnG_OUT,Ehat] = feasibility(t_des,r1,v1,tol)

global muCan Re DU TU

% Compute F&G Solution
time    = linspace(0,t_des,100);
rFnG    = [];
vFnG    = [];
FnG_OUT = [];
t0      = 0;
for i = 1:length(time)
    [r,v,Ehat] = FnG(t0,time(i),r1,v1,muCan,tol);
    rFnG       = [rFnG; r'];
    vFnG       = [vFnG; v'];
end
FnG_OUT  = [rFnG vFnG];

% Feasibility
Ecol   = 0;
EscVel = 0;
for ecnt = 1:length(FnG_OUT(:,1))
    normR(ecnt) = norm(FnG_OUT(ecnt,1:3));
    normV(ecnt) = norm(FnG_OUT(ecnt,4:6))/Re*TU;
    % Earth Collision
    if normR(ecnt) < 1.05
        Ecol = 1;
    end
    % Escape velocity
    if normV(ecnt) > 11.2
        EscVel = 1;
    end
end

return