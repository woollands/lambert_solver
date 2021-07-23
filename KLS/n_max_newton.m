% n_max_newton.m
% AUTHOR:           Robyn Woollands (robyn.woollands@gmail.com)
% DATE WRITTEN:     May, 2016
% LAST MODIFIED:    May, 2016
% AFFILIATION:      Department of Aerospace Engineering, Texas A & M University, College Station, TX
%
% DESCRIPTION:      Solves for the max number of revolutions using Newton's method

function [Nmax,alpha_0,beta_0,t_min,a_min,itr] = n_max_newton(s,c,a_m,theta,t_des,t_m,parab,tol)

global muCan

N       = 0;
a       = 1.001*a_m;                    % Initial guess for semimajor axis
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

% Determine Nmax

Nmax      = 0;
t_min_tmp = 0;
t_min     = 0;
a_min     = 0;
itr       = 0;
while t_min_tmp < t_des && parab == 0
    Nmax = N;
    N    = N + 1;
    f    = 10;
    itr  = 0;
    while abs(f) > tol
        
        % Transendental Equation
        f     = (6*N*pi + 3*(alpha-beta) - (sin(alpha)-sin(beta)))...
            *(sin(alpha-beta) + sin(alpha)-sin(beta)) - 8*(1-cos(alpha-beta)); % Eq. 5.44
        
        xi    = alpha - beta;
        eta   = sin(alpha) - sin(beta);
        
        % Analytical derivative (df_da)
        dfda  = ((6*N*pi + 3*xi - eta)*(cos(xi) + cos(alpha)) + ...
            (3-cos(alpha))*(sin(xi) + eta) - 8*sin(xi))*(-1/a*tan(alpha/2)) + ...
            ((6*N*pi + 3*xi - eta)*(-cos(xi) - cos(alpha)) +...
            (-3 - cos(beta))*(sin(xi) + eta) + 8*sin(xi))*(-1/a*tan(beta/2));   % Eq. 5.45
        
        % Newton's method
        a = a - f/dfda;
        
        % Update
        alpha = 2*asin(sqrt(s/(2*a)));          % Eq. 5.26
        beta  = 2*asin(sqrt((s-c)/(2*a)));      % Eq. 5.27
        
        % Counter
        itr = itr + 1;
        abs(f);
        
        % Max iterations
        if itr > 30
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