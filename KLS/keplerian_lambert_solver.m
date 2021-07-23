% keplerian_lambert_solver.m
% AUTHOR:           Robyn Woollands (robyn.woollands@gmail.com)
% DATE WRITTEN:     Dec, 2015
% LAST MODIFIED:    May, 2016
% AFFILIATION:      Department of Aerospace Engineering, Texas A & M University, College Station, TX
%
% DESCRIPTION:      Solves the Keplerian Lambert problem over multiple revolutions
%
% REFERENCES:
% 1. Ochoa, S., Prussing, J., "Multiple revolution solutions to Lambert's
%    problem", AAS/AIAA spaceflight mechanics meeting, Kissimmee (1992).
%
% 2. Woollands, R., "Regularization and Computational Methods for Precise
%    Solution of Perturbed Orbit Transfer Problems", PhD Dissertation,
%    Texas A&M University, College Station, TX, 2016.
%
% 3. Woollands, R. Read, J., Hernandez, K., Probe, A., Junkins, J., "Unified
%    Lambert Tool for Massively Parallel Applications in Space Situational
%    Awareness", J of Astronautical Sciences, accepted 2017.


function keplerian_lambert_solver(r1,r2,t_des,tol,fig)

global mu muCan Re DU TU VU

% Load Constants
consts;

% Colors for plotting
colors  = {'b-','r-','g-','m-','c-','y-','k-',...
    'b--','r--','g--','m--','c--','y--',...
    'b-.','r-.','g-.','m-.','c-.','y-.'};

% Convert to Canonical
r1    = r1./DU;
r2    = r2./DU;
t_des = t_des/TU;

retro = 0;
V0    = [];
for rr = 1:2    % If retrograde orbits exist compute them
    %% Lambert Initialization
    % Magnitude
    R1      = sqrt(r1*r1');
    R2      = sqrt(r2*r2');
    
    c       = norm(r2 - r1);               % Chord
    s       = (R1 + R2 + c)/2;             % Semiperimeter
    a_m     = s/2;                         % Minimum energy semimajor axis
    theta   = acos(r1*r2'/(R1*R2));        % Angle between position vectors
    
    % Number of revs
    N       = 0;
    
    % Retrograde Check
    if rr == 2
        theta = 2*pi - theta;
    end
    
    %% Minimum energy transfer time
    [t_m,alpha_m,beta_m] = t_min_energy(s,c,a_m,theta);
    
    %% Calculate t_parabolic
    [t_p,parab] = t_parabolic(s,c,theta,t_des);
    
    %% Determine Nmax
    % Newton's Method
    [Nmax,alpha_0,beta_0,t_min,a_min,itr] = n_max_newton(s,c,a_m,theta,t_des,t_m,parab,tol);
    
    % Bisection Method (if Newton fails)
    if N > 0 && itr > 30
        [Nmax,alpha_0,beta_0,t_min,a_min] = n_max_bisection(s,c,a_m,theta,t_des,t_m,parab,tol);
    end
    
    %% Compute Transfer Solutions
    if parab ~= 1  % Parabolic check
        
        % Loop through all solution cases
        for ncnt=N+1:2*Nmax+1
            
            % Compute semimajor axis for transfer orbit
            % Newton's Method
            [a,t_curr,alpha,beta,tmp,itr,err1] = a_transfer_newton(s,c,a_m,theta,t_des,t_min,a_min,alpha_0,beta_0,alpha_m,beta_m,N,Nmax,ncnt,tol);
            
            % Bisection method (if Newton fails)
            if N > 1 && itr > 150
                [a,t_curr,alpha,beta,tmp,itr,err2] = a_transfer_bisection(s,c,a_m,theta,t_des,t_min,a_min,alpha_0,beta_0,alpha_m,beta_m,N,Nmax,ncnt,tol);
            end
            
            % Compute velocity and delta v
            [v1,v2] = velocity(r1,r2,R1,R2,c,alpha,beta,a,t_curr);
            
            % Retrograde Check
            retro = retrograde(r1,v1);
            
            % Check transfer solution feasibility (Earth collisions)
            [Ecol,EscVel,FnG_OUT,Ehat] = feasibility(t_des,r1,v1,tol);
            
            plot1_inform_user; % if fig = 1
            
            % Increase N
            if mod(ncnt,2) == 1
                N = N+1;
            end
            
            store_data;
        end
    end
    if retro == 0
        break
    end
end

save data data

plot2_inform_user; % if setplot = 1

return

