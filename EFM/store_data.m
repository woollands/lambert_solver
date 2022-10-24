% Build Data Storage Matrices

% If the orbit is prograde
if retro == 0
    if isnan(delV) || max(abs(r2-FnG_OUT(end,1:3))) > tol
        % If the candidate solution did not converge
        N_soln_p(kk,xx,ncnt)  = 0;
        RV_poss(:,:,kk,xx,ncnt) = zeros(100,6);
        N_soln_f(kk,xx,ncnt)  = 0;
        RV_feas(:,:,kk,xx,ncnt) = zeros(100,6);
        delV  = 0;
        delVD = 0;
        delVA = 0;
    else
        % If the candidate solution converged 
        
        % Possible Solutions
        N_soln_p(kk,xx,ncnt)  = 1;
        RV_poss(:,:,kk,xx,ncnt) = FnG_OUT;
        
        if Ecol == 0 && EscVel == 0
            % Feasible Solutions
            N_soln_f(kk,xx,ncnt)    = 1;
            RV_feas(:,:,kk,xx,ncnt) = FnG_OUT;
        else
            % Infeasible Solutions
            N_soln_f(kk,xx,ncnt)    = 0;
            RV_feas(:,:,kk,xx,ncnt) = zeros(100,6);
            delV  = 0;
            delVD = 0;
            delVA = 0;
        end
    end
    % Delta Vs
    DelV(kk,xx,ncnt)  = real(delV);     % Total DV
    DelVD(kk,xx,ncnt) = real(delVD);    % Departure DV
    DelVA(kk,xx,ncnt) = real(delVA);    % Arrival DV
end

% If the orbit is retrograde
if retro == 1
    if isnan(delV) || max(abs(r2-FnG_OUT(end,1:3))) > tol
        % If the candidate solution did not converge
        R_N_soln_p(kk,xx,ncnt)    = 0;
        R_RV_poss(:,:,kk,xx,ncnt) = zeros(100,6);
        R_N_soln_f(kk,xx,ncnt)    = 0;
        R_RV_feas(:,:,kk,xx,ncnt) = zeros(100,6);
        delV  = 0;
        delVD = 0;
        delVA = 0;
    else
        % If the candidate solution converged
        
        % Possible Solutions
        R_N_soln_p(kk,xx,ncnt)    = 1;
        R_RV_poss(:,:,kk,xx,ncnt) = FnG_OUT;
        
        if Ecol == 0 && EscVel == 0
            % Feasible Solutions
            R_N_soln_f(kk,xx,ncnt)    = 1;
            R_RV_feas(:,:,kk,xx,ncnt) = FnG_OUT;
        else
            % Infeasible Solutions
            R_N_soln_f(kk,xx,ncnt)    = 0;
            R_RV_feas(:,:,kk,xx,ncnt) = zeros(100,6);
            delV  = 0;
            delVD = 0;
            delVA = 0;
        end
    end
    % Delta Vs
    R_DelV(kk,xx,ncnt)        = real(delV);     % Total DV
    R_DelVD(kk,xx,ncnt)       = real(delVD);    % Departure DV
    R_DelVA(kk,xx,ncnt)       = real(delVA);    % Arrival DV
end
