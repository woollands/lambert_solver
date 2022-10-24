% EFM_generate.m
% AUTHOR:           Robyn Woollands (robyn.woollands@gmail.com)
% DATE WRITTEN:     June, 2014
% LAST MODIFIED:    May, 2016
% AFFILIATION:      Department of Aerospace Engineering, Texas A & M University, College Station, TX
%
% DESCRIPTION:      Generates extremal field maps for elliptic orbit transfers
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


function EFM_generate(input)

global mu muCan Re DU VU TU

% clear
% close all
% clc
%% Initialization

% Load Constants
consts;

filename = input;

% Load User Input
eval(input)

% EFM_input_Ex1;

%% Generate Departure & Arrival Orbits (Keplerian)

% Compute Cartesian Position, Velocity & Orbit Period
[rD,vD] = elm2rv(DepA,DepE,DepI,DepOm,DepW,DepM0,0,mu,tol);
[rA,vA] = elm2rv(ArrA,ArrE,ArrI,ArrOm,ArrW,ArrM0,0,mu,tol);
DepP    = 2*pi*sqrt(DepA^3 / mu);
ArrP    = 2*pi*sqrt(ArrA^3 / mu);

[TIME,DepOrbit,ArrOrbit,DepTime,ArrTimeO,ArrTimeE] = generate_orbits(DimH,DimV,DepP,EFMres,rD,rA,vD,vA,tol);

plot0_inform_user; % if setplot = 1

%% EFM Generation
for xx = 1:length(DepTime)         % EFM x-axis (departure time)
    for kk = 1:length(ArrTimeE)    % EFM y-axis (time-of-flight)
        
%         disp(['x-axis: ',num2str(xx),' of ',num2str(length(DepTime)),',',...
%             '      y-axis: ',num2str(kk),' of ',num2str(length(ArrTimeE))])
        
        retro = 0;
        for rr = 1:2    % If retrograde orbits exist compute them
            %% Lambert Initialization
            [r1,r2,R1,R2,v0A,v0B,c,s,a_m,theta,t_des,N] = initialize(xx,kk,TIME,DepOrbit,ArrOrbit);
            
            plot1_inform_user; % if setplot = 1
            
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
                    if N > 0 && itr > 150
                        [a,t_curr,alpha,beta,tmp,itr,err2] = a_transfer_bisection(s,c,a_m,theta,t_des,t_min,a_min,alpha_0,beta_0,alpha_m,beta_m,N,Nmax,ncnt,tol);
                    end
                    
                    % Compute velocity and delta v
                    [v1,v2,delV,delVD,delVA] = velocity(r1,r2,v0A,v0B,R1,R2,c,alpha,beta,a,t_curr);
                    
                    % Retrograde Check
                    retro = retrograde(r1,v1);
    
                    % Check transfer solution feasibility (Earth collisions)
                    [Ecol,EscVel,FnG_OUT,Ehat] = feasibility(t_des,r1,v1,tol);
                    
                    plot2_inform_user; % if setplot = 1
                    
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
    end
    disp(['Progress: ',num2str(xx),' of ',num2str(length(DepTime)),' Completed.'])
end

plot3_inform_user; % if setplot = 1

save_data;

return

