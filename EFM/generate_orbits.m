% generate_orbits.m
% AUTHOR:           Robyn Woollands (robyn.woollands@gmail.com)
% DATE WRITTEN:     May, 2016
% LAST MODIFIED:    May, 2016
% AFFILIATION:      Department of Aerospace Engineering, Texas A & M University, College Station, TX
%
% DESCRIPTION:      Generates departure and arrival orbits

function [TIME,DepOrbit,ArrOrbit,DepTime,ArrTimeO,ArrTimeE] = generate_orbits(DimH,DimV,DepP,EFMres,rD,rA,vD,vA,tol)

global mu DU TU

t0       = 0;                            % Initial Departure Time
tfH      = DimH*DepP;                    % Final Departure Time
dt       = tfH/EFMres;                   % Time Interval

tfVefm   = (DimV)*DepP;                  % Time of Flight (y-axis)
tfVorb   = (DimH+DimV)*DepP + 10*dt;     % Available Time of Flight (longer than tfVefm)

DepTime  = [t0:dt:tfH];                  % Vector of Departure Times
ArrTimeE = [t0:dt:tfVefm];               % Vector of Times of Flight
ArrTimeO = [t0:dt:tfVorb];               % Vector of Available Times of Flight

for gg = 1:2
    rFnG        = [];
    vFnG        = [];
    if gg == 1
        R    = rD;
        V    = vD;
        time = DepTime;
    elseif gg == 2
        R    = rA;
        V    = vA;
        time = ArrTimeO;
    end
    check = 0;
    for i = 1:length(time)
        [r, v]      = FnG(t0,time(i),R,V,mu,tol);
        rFnG        = [ rFnG; r' ];
        vFnG        = [ vFnG; v' ];
        if norm(r) > 1.03*DU
            check(i)    = 1;
        end
    end
    Soln = [rFnG vFnG];
    if sum(check) < length(time)
        disp('Orbit Collides with Earth!!!')
        break
    end
    clear check
    % Save Departure & Arrival Orbits (canonical Units)
    if gg == 1
        TIME     = ArrTimeE'./TU;
        DepOrbit = [Soln(:,1:3)./DU Soln(:,4:6)./DU.*TU];
    elseif gg == 2
        ArrOrbit = [Soln(:,1:3)./DU Soln(:,4:6)./DU.*TU];
    end
end

return