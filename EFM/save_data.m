
% Save Departure & Arrival Orbits
data.DepOrbit = DepOrbit;
data.ArrOrbit = ArrOrbit;
data.DepTime  = DepTime;
data.ArrTimeE = ArrTimeE;

% Save prograde EFM data
data.poss = N_soln_p;
data.feas = N_soln_f;
data.DV   = DelV;
data.DVD  = DelVD;
data.DVA  = DelVA;

% Save retrograde EFM data
data.R_poss = R_N_soln_p;
data.R_feas = R_N_soln_f;
data.R_DV   = R_DelV;
data.R_DVD  = R_DelVD;
data.R_DVA  = R_DelVA;

% Save trajectory data
data.RV_poss   = RV_poss;
data.RV_feas   = RV_feas;
data.R_RV_poss = R_RV_poss;
data.R_RV_feas = R_RV_feas;

save(filename,'data','-v7.3');
% mkdir([filename])
% movefile([filename,'.mat'],[filename])
% tar([filename,'.tar'],[filename])
% cd([filename])
% delete([filename,'.mat'])
% cd ../
% rmdir([filename])
