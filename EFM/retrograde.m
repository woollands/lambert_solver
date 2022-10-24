% retrograde.m
% AUTHOR:           Robyn Woollands (robyn.woollands@gmail.com)
% DATE WRITTEN:     May, 2016
% LAST MODIFIED:    May, 2016
% AFFILIATION:      Department of Aerospace Engineering, Texas A & M University, College Station, TX
%
% DESCRIPTION:      Checks the z-component of the angular momentum vector
%                   to determine if the transfer was a retrograde orbit.

function retro = retrograde(r1,v1)
% Retrograde Check (z-component of angular momentum vector)
hvec = cross(r1,v1);
if hvec(3) < 0
    retro = 1;
else
    retro = 0;
end

return