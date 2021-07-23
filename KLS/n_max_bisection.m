% n_max_bisection.m
% AUTHOR:           Robyn Woollands (robyn.woollands@gmail.com)
% DATE WRITTEN:     May, 2016
% LAST MODIFIED:    May, 2016
% AFFILIATION:      Department of Aerospace Engineering, Texas A & M University, College Station, TX
%
% DESCRIPTION:      Solves for the max number of revolutions using the bisection method

function [Nmax,alpha_0,beta_0,t_min,a_min] = n_max_bisection(s,c,a_m,theta,t_des,t_m,parab,tol)

global muCan

N       = 0;
a       = 1.001*a_m;                          % Initial guess for semimajor axis
alpha_0 = 2*asin(sqrt(s/(2*a)));        % Eq. 5.26
beta_0  = 2*asin(sqrt((s-c)/(2*a)));    % Eq. 5.27

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

N         = 0;
Nmax      = 0;
t_min_tmp = 0;
t_min     = 0;
a_min     = 0;
while t_min_tmp < t_des && parab == 0
    
    Nmax = N;
    N    = N + 1;
    itr  = 0;
    
    % Transendental Equation
    f     = (6*N*pi + 3*(alpha-beta) - (sin(alpha)-sin(beta)))...
        *(sin(alpha-beta) + sin(alpha)-sin(beta)) - 8*(1-cos(alpha-beta)); % Eq. 5.44
    
    a  = a_m;
    a1 = a_m;
    i  = 1;
    ss = sign(f);
    % Determine initial guesses for semimajor axis
     while sign(f) == ss   
        
        % Transendental Equation
        f     = (6*N*pi + 3*(alpha-beta) - (sin(alpha)-sin(beta)))...
            *(sin(alpha-beta) + sin(alpha)-sin(beta)) - 8*(1-cos(alpha-beta)); % Eq. 5.44
        
        % Update
        alpha = 2*asin(sqrt(s/(2*a)));          % Eq. 5.26
        beta  = 2*asin(sqrt((s-c)/(2*a)));      % Eq. 5.27
        a2    = a;
    
        % Increase semimajor axis guess
        a = a + 0.5;
        
        % Counter
        if i > 150
            break
        end
        
     end
    
    % Bisection method to determine a
    while abs(f) > tol
                
        % Transendental Equation
        f     = (6*N*pi + 3*(alpha-beta) - (sin(alpha)-sin(beta)))...
            *(sin(alpha-beta) + sin(alpha)-sin(beta)) - 8*(1-cos(alpha-beta)); % Eq. 5.44
        
        % Update guesses
        if f < 0
            a1 = a;
        else
            a2 = a;
        end
        
        % Update
        a     = (a2 + a1)/2 + a1;
        alpha = 2*asin(sqrt(s/(2*a)));          % Eq. 5.26
        beta  = 2*asin(sqrt((s-c)/(2*a)));      % Eq. 5.27
        
        % Counter
        itr = itr + 1;
        abs(f);
        
        % Max iterations
        if itr > 300
            break
        end
        
    end
        
    % Clean up (miniscule img part)
    a      = real(a);
    alpha  = real(alpha);
    beta   = real(beta);
    
    if theta >= pi && theta < 2*pi
        beta = -beta;   % Eq. 5.31b
    end
    
    t_min_tmp = sqrt((a^3)/muCan)*(2*N*pi + alpha - beta - (sin(alpha) - sin(beta))); % Eq. 5.41
    
    if t_min_tmp < t_des
        t_min = t_min_tmp;
        a_min = a;
    end
    
end

return
