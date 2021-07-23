% Build Data Storage Matrices

% If the orbit is prograde
if retro == 0
    if isnan(norm(v1)) || max(abs(r2-FnG_OUT(end,1:3))) > tol
        % If the candidate solution did not converge
        N_soln_p(ncnt)  = 0;
        RV_poss(:,:,ncnt) = zeros(100,6);
        N_soln_f(ncnt)  = 0;
        RV_feas(:,:,ncnt) = zeros(100,6);
    else
        % If the candidate solution converged 
        
        % Possible Solutions
        N_soln_p(ncnt)  = 1;
        RV_poss(:,:,ncnt) = FnG_OUT;
        
        if Ecol == 0 && EscVel == 0
            % Feasible Solutions
            N_soln_f(ncnt)    = 1;
            RV_feas(:,:,ncnt) = FnG_OUT;
            V0 = [V0;FnG_OUT(1,4:6).*DU./TU];
        else
            % Infeasible Solutions
            N_soln_f(ncnt)    = 0;
            RV_feas(:,:,ncnt) = zeros(100,6);
        end
    end
    data.poss    = N_soln_p;
    data.feas    = N_soln_f;
    data.RV_poss = RV_poss;
    data.RV_feas = RV_feas;
    data.V0      = V0;
end

% If the orbit is retrograde
if retro == 1
    if isnan(norm(v1)) || max(abs(r2-FnG_OUT(end,1:3))) > tol
        % If the candidate solution did not converge
        R_N_soln_p(ncnt)    = 0;
        R_RV_poss(:,:,ncnt) = zeros(100,6);
        R_N_soln_f(ncnt)    = 0;
        R_RV_feas(:,:,ncnt) = zeros(100,6);
    else
        % If the candidate solution converged
        
        % Possible Solutions
        R_N_soln_p(ncnt)    = 1;
        R_RV_poss(:,:,ncnt) = FnG_OUT;
        
        if Ecol == 0 && EscVel == 0
            % Feasible Solutions
            R_N_soln_f(ncnt)    = 1;
            R_RV_feas(:,:,ncnt) = FnG_OUT;
            V0 = [V0;FnG_OUT(1,4:6).*DU./TU];
        else
            % Infeasible Solutions
            R_N_soln_f(ncnt)    = 0;
            R_RV_feas(:,:,ncnt) = zeros(100,6);
        end
    end
    data.R_poss    = R_N_soln_p;
    data.R_feas    = R_N_soln_f;
    data.R_RV_poss = R_RV_poss;
    data.R_RV_feas = R_RV_feas;
    data.V0        = V0;
end
