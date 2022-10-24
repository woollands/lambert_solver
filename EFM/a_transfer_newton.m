% a_transfer_newton.m
% AUTHOR:           Robyn Woollands (robyn.woollands@gmail.com)
% DATE WRITTEN:     May, 2016
% LAST MODIFIED:    May, 2016
% AFFILIATION:      Department of Aerospace Engineering, Texas A & M University, College Station, TX
%
% DESCRIPTION:      Solves for the semimajor axis using Newton's method
%
% REFERENCES:       
% 1. Ochoa, S., Prussing, J., Multiple revolution solutions to Lambert's
% problem, AAS/AIAA spaceflight mechanics meeting, Kissimmee (1992).

function [a,t_curr,alpha,beta,tmp,itr,g] = a_transfer_newton(s,c,a_m,theta,t_des,t_min,a_min,alpha_0,beta_0,alpha_m,beta_m,N,Nmax,ncnt,tol)

global muCan

% Initialize
itr = 0;
g   = 10;
a   = 1.001*a_m;

% Compute time corresponding to min energy transfer
t_m = sqrt(a_m^3/muCan)*(2*N*pi + alpha_m - beta_m - (sin(alpha_m) - sin(beta_m))); % Eq. 5.42

% Beta
if theta >= 0 && theta < pi
    beta = beta_0;                      % Eq. 5.31a
elseif theta >= pi && theta < 2*pi
    beta = -beta_0;                     % Eq. 5.31b
end

% Alpha
if t_des <= t_m
    tmp   = ['Lower Branch N = ',num2str(N)];
    alpha = alpha_0;                    % Eq. 5.32a
elseif t_des > t_m
    tmp   = ['Upper Branch N = ',num2str(N)];
    alpha = 2*pi - alpha_0;             % Eq. 5.32b
end

% Determine starting "a" when t_min < t_des < t_m
tmp  = [''];
flag = 0;
if N > 0 && N == Nmax
    if t_des > t_min && t_des <= t_m
        if mod(ncnt,2) == 0
            tmp   = ['Lower Branch N = ',num2str(N)];
            a     = 0.95*a_min;
            alpha = alpha_0;
        elseif mod(ncnt,2) == 1
            tmp   = ['Lower Branch N = ',num2str(N)];
            a     = 1.05*a_min;
            alpha = alpha_0;
        end
        flag = 1;
    end
end

% Convey upper/lower branch info to user
if flag == 0 && ncnt > 1 && mod(ncnt,2) == 1
    alpha = alpha_0;
    tmp   = ['Lower Branch N = ',num2str(N)];
elseif flag == 0 && mod(ncnt,2) == 0
    tmp   = ['Upper Branch N = ',num2str(N)];
    alpha = 2*pi - alpha_0;
end

while abs(g) > tol
    
    % Time with "current semimajor"
    t_curr = sqrt((a^3)/muCan)*(2*N*pi + alpha - beta - (sin(alpha) - sin(beta))); % Eq. 5.41
    
    % Transendental Equation
    f     = (6*N*pi + 3*(alpha-beta) - (sin(alpha)-sin(beta)))...
        *(sin(alpha-beta) + sin(alpha)-sin(beta)) - 8*(1-cos(alpha-beta));         % Eq. 5.44
    
    % Analytical derivative (dt_da)
    dgda = 0.5*sqrt(a/muCan)/(sin(alpha-beta)+(sin(alpha)-sin(beta)))*f;           % Eq. 5.43
    
    % Error
    g = t_curr - t_des;                   % Eq. 5.46
    
    % Newton's method
    a = a - g/dgda;
    
    a = real(a);
    
    % Update
    alpha = 2*asin(sqrt(s/(2*a)));        % Eq. 5.26
    beta  = 2*asin(sqrt((s-c)/(2*a)));    % Eq. 5.27
    
    % Beta
    if theta >= pi && theta < 2*pi
        beta = -beta;                     % Eq. 5.31b
    end
    
    % Cases for N = 0
    if N == 0
        if t_des > t_m
            alpha = 2*pi - alpha;         % Eq. 5.32b
        end
    end
    
    % Cases for N > 0
    if N > 0
        if ncnt > 1 && mod(ncnt,2) == 0
            if t_des >= t_m
                alpha = 2*pi - alpha;     % Eq. 5.32b
            end
        end
    end
    
    % Counter
    itr = itr + 1;
    abs(g);
    
    % Max iterations
    if itr > 150
        break
    end
    
end

return