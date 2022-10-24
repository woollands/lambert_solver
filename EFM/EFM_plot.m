% EFM_plot.m
% AUTHOR:           Robyn Woollands (robyn.woollands@gmail.com)
% DATE WRITTEN:     June, 2014
% LAST MODIFIED:    May, 2016
% AFFILIATION:      Department of Aerospace Engineering, Texas A & M University, College Station, TX
%
% DESCRIPTION:      Interactive plotting tool for studying EFMs

function EFM_plot(input)

clearvars -except input
close all

filename = input;
load([filename,'.mat'])
    
consts;


max_solns      = 9;
saturate_level = 11;

% Departure & Arrival Orbits
DepOrbit = data.DepOrbit;
ArrOrbit = data.ArrOrbit;

% Possible and Feasible Solutions
DATAp    = data.poss;
DATAf    = data.feas;
R_DATAp  = data.R_poss;
R_DATAf  = data.R_feas;

% Delta V (Prograde and Retrograde)
DATAv    = data.DV.*DU/TU;
R_DATAv  = data.R_DV.*DU/TU;

% Transfer Trajectories
RV_poss  = data.RV_poss;
RV_feas  = data.RV_feas;

% Ticks for Axes
DepTime  = data.DepTime;
ArrTimeE = data.ArrTimeE;
xmin     = DepTime(1)/3600;
xmax     = DepTime(end)/3600;
ymin     = ArrTimeE(1)/3600;
ymax     = ArrTimeE(end)/3600;

load('topo.mat','topo','topomap1');

colors  = {'k-','g^-','gs-','m^-','ms-','c^-','cs-',...
    'y^-','ys-'};

% Number of Solutions
for i = 1:size(DATAp,3)
    if i == 1
        poss   = DATAp(:,:,i);
        feas   = DATAf(:,:,i);
        R_poss = R_DATAp(:,:,i);
        R_feas = R_DATAf(:,:,i);
    elseif i > 1
        poss   = poss + DATAp(:,:,i);
        feas   = feas + DATAf(:,:,i);
        R_poss = R_poss + R_DATAp(:,:,i);
        R_feas = R_feas + R_DATAf(:,:,i);
    end
end

% Total Delta V (min of prograde & retrograde)
% Saturate Zeros
for i = 1:size(DATAv,1)
    for j = 1:size(DATAv,2)
        for k = 1:size(DATAv,3)
            if DATAv(i,j,k) == 0
                DATAv(i,j,k) = saturate_level;
            end
        end
    end
end
% Build Prograde EFM (min DV)
min_efm = saturate_level;
for i = 1:size(DATAv,1)
    for j = 1:size(DATAv,2)
        EFM(i,j) = min(min(DATAv(i,j,:)));
        NUM(i,j) = min(find(EFM(i,j) == DATAv(i,j,:)));
        if EFM(i,j) < min_efm
            min_efm  = EFM(i,j);
            k        = find(EFM(i,j) == DATAv(i,j,:));
            ind      = [i j k];
            NUM(i,j) = k;
        end
    end
end
% Saturate Zeros
for i = 1:size(R_DATAv,1)
    for j = 1:size(R_DATAv,2)
        for k = 1:size(R_DATAv,3)
            if R_DATAv(i,j,k) == 0
                R_DATAv(i,j,k) = saturate_level;
            end
        end
    end
end
% Build Retrograde EFM (min DV)
min_efm = saturate_level;
for i = 1:size(R_DATAv,1)
    for j = 1:size(R_DATAv,2)
        R_EFM(i,j) = min(min(R_DATAv(i,j,:)));
        R_NUM(i,j) = min(find(R_EFM(i,j) == R_DATAv(i,j,:)));
        if R_EFM(i,j) < min_efm
            min_efm  = R_EFM(i,j);
            k        = find(R_EFM(i,j) == R_DATAv(i,j,:));
            R_ind    = [i j k];
            R_NUM(i,j) = k;
        end
    end
end
% Min of Prograde & Retrograde
for i = 1:size(EFM,1)
    for j = 1:size(EFM,2)
        if R_EFM(i,j) > 0 && R_EFM(i,j) < EFM(i,j)
            EFM(i,j)  = R_EFM(i,j);
            poss(i,j) = R_poss(i,j);
            feas(i,j) = R_feas(i,j);
        end
    end
end

%% Plots

% Number of Possible Solutions
figure('rend','painters','pos',[100 100 1500 800])
ax1 = subplot(2,3,1);
imagesc([xmin xmax],[ymin ymax], poss, [0, 9] )
set(gca, 'FontName', 'Helvetica','FontSize',12)
set(gca,'YDir','normal')
colorbar
colormap(ax1,'jet')
colorbar('FontName', 'Helvetica','FontSize',12)
ylabel('Time of Flight (Hours)')
xlabel('t_0 (Hours Past Start)')
title('Number of Possible Solutions')

% Number of Feasible Solutions
ax2 = subplot(2,3,2);
imagesc([xmin xmax],[ymin ymax], feas, [0, 9] )
set(gca, 'FontName', 'Helvetica','FontSize',12)
set(gca,'YDir','normal')
colorbar
colormap(ax2,'jet')
colorbar('FontName', 'Helvetica','FontSize',12)
ylabel('Time of Flight (Hours)')
xlabel('t_0 (Hours Past Start)')
title('Number of Feasible Solutions')

% Minimum Total Delta V
cmap        = jet(ceil(saturate_level));
cmap(end,:) = ones(1,3);
ax3         = subplot(2,3,3);
imagesc([xmin xmax],[ymin ymax], EFM, [0, saturate_level] )
hold on
plot(DepTime(ind(2))/3600,DepTime(ind(1))/3600,'m*','MarkerSize',15)
plot(DepTime(ind(2))/3600,DepTime(ind(1))/3600,'mo','MarkerSize',15)
colormap(ax3,cmap);
h = colorbar;
set(h, 'ylim', [0 floor(saturate_level-1)])
set(gca,'YDir','normal','FontName', 'Helvetica','FontSize',12)
ylabel('Time of Flight (Hours)')
xlabel('t_0 (Hours Past Start)')
title('Min Total \Delta V (km/s)')


disp('Click on EFMs to plot trajectories. Type Ctrl C in command window to quit.')

% User selects points
while 1
    
    % Determine Data Point
    [x1,y1] = ginput(1);
    x2      = min(find(DepTime > x1*3600));
    y2      = min(find(ArrTimeE > y1*3600));
    
    % Plot points on EFMs
    ax1     = subplot(2,3,1);
    hold on
    plot(x1,y1,'w+','MarkerSize',15)
    plot(x1,y1,'k.','MarkerSize',10)
    plot(x1,y1,'ko','MarkerSize',15)
    ax2 = subplot(2,3,2);
    hold on
    plot(x1,y1,'w+','MarkerSize',15)
    plot(x1,y1,'k.','MarkerSize',10)
    plot(x1,y1,'ko','MarkerSize',15)
    ax3 = subplot(2,3,3);
    hold on
    plot(x1,y1,'w+','MarkerSize',15)
    plot(x1,y1,'k.','MarkerSize',10)
    plot(x1,y1,'ko','MarkerSize',15)
    
    %% Possible Transfers
    leg = [];
    for i = 1:max_solns
        RV = RV_poss(:,:,y2,x2,i);
        ax4 = subplot(2,3,4);
        if i == 1
            cla;
            hold on
            plot3(DepOrbit(:,1),DepOrbit(:,2),DepOrbit(:,3),'b-','Linewidth',3)
            plot3(ArrOrbit(:,1),ArrOrbit(:,2),ArrOrbit(:,3),'r-','Linewidth',3)
            plot3(RV(1,1),RV(1,2),RV(1,3),'b.','MarkerSize',40)
            plot3(RV(end,1),RV(end,2),RV(end,3),'r.','MarkerSize',40)
        end
        plot3(RV(:,1),RV(:,2),RV(:,3),colors{i})
        grid on
        axis equal
        
        % Legend
        if i == 1
            leg = ['Orbit A';'Orbit B';'Start  ';'End    '];
        end
        if norm(RV(i,1:3)) ~= 0
            clear legend
            if i == 1
                leg = [leg; 'N0     '];
            elseif i > 1
                if mod(i,2) == 0
                    branch = 'U';
                elseif mod(i,2) == 1
                    branch = 'L';
                end
                leg = [leg; ['N',num2str(floor(i/2)),branch,'    ']];
            end
        end  
    end
    set(gca, 'FontName', 'Helvetica','FontSize',12)
    set(gca,'YDir','normal')
    xlabel('X (Earth Radii)')
    ylabel('Y (Earth Radii)')
    zlabel('Z (Earth Radii)')
    title('Possible Transfer Trajectories')
    legend(leg,'Location','SouthEast')
    
%     colormap(topomap1);
%     % Create the surface.
%     [x,y,z] = sphere(50);
%     props.AmbientStrength = 0.1;
%     props.DiffuseStrength = 1;
%     props.SpecularColorReflectance = .5;
%     props.SpecularExponent = 20;
%     props.SpecularStrength = 1;
%     props.FaceColor= 'texture';
%     props.EdgeColor = 'none';
%     props.FaceLighting = 'phong';
%     props.Cdata = topo;
%     surface(x,y,z,props);
    
    %% Feasible Transfer Trajectories
    for i = 1:max_solns
        RV = RV_feas(:,:,y2,x2,i);
        ax5 = subplot(2,3,5);
        if i == 1
            cla;
            hold on
            plot3(DepOrbit(:,1),DepOrbit(:,2),DepOrbit(:,3),'b-','Linewidth',3)
            plot3(ArrOrbit(:,1),ArrOrbit(:,2),ArrOrbit(:,3),'r-','Linewidth',3)
            plot3(RV(1,1),RV(1,2),RV(1,3),'b.','MarkerSize',40)
            plot3(RV(end,1),RV(end,2),RV(end,3),'r.','MarkerSize',40)
        end
        if norm(RV(1,1:3)) ~= 0
            plot3(RV(:,1),RV(:,2),RV(:,3),colors{i})
        end
        grid on
        axis equal
        
        % Legend
        if i == 1
            leg = ['Orbit A';'Orbit B';'Start  ';'End    '];
        end
        if norm(RV(1,1:3)) ~= 0
            if i == 1
                leg = [leg; 'N0     '];
            elseif i > 1
                if mod(i,2) == 0
                    branch = 'U';
                elseif mod(i,2) == 1
                    branch = 'L';
                end
                leg = [leg; ['N',num2str(floor(i/2)),branch,'    ']];
            end
        end
    end
    set(gca, 'FontName', 'Helvetica','FontSize',12)
    set(gca,'YDir','normal')
    xlabel('X (Earth Radii)')
    ylabel('Y (Earth Radii)')
    zlabel('Z (Earth Radii)')
    title('Feasible Transfer Trajectories')
    legend(leg,'Location','SouthEast')
    
%     % Plot Earth
%     colormap(topomap1);
%     [x,y,z]                        = sphere(50);
%     props.AmbientStrength          = 0.1;
%     props.DiffuseStrength          = 1;
%     props.SpecularColorReflectance = .5;
%     props.SpecularExponent         = 20;
%     props.SpecularStrength         = 1;
%     props.FaceColor                = 'texture';
%     props.EdgeColor                = 'none';
%     props.FaceLighting             = 'phong';
%     props.Cdata                    = topo;
%     surface(x,y,z,props);
    
    %% EFM Minimum Transfer Trajectory
    clear data RV
    RV1 = RV_feas(:,:,y2,x2,NUM(y2,x2));  % Selected Min
    RV2 = RV_feas(:,:,ind(1),ind(2),ind(3));  % EFM Min
    ax6 = subplot(2,3,6);
    cla;
    hold on
    plot3(RV1(:,1),RV1(:,2),RV1(:,3),'k*-')
    plot3(RV2(:,1),RV2(:,2),RV2(:,3),'m*-')
    plot3(DepOrbit(:,1),DepOrbit(:,2),DepOrbit(:,3),'b-','Linewidth',3)
    plot3(ArrOrbit(:,1),ArrOrbit(:,2),ArrOrbit(:,3),'r-','Linewidth',3)
    plot3(RV1(1,1),RV1(1,2),RV1(1,3),'b.','MarkerSize',40)
    plot3(RV1(end,1),RV1(end,2),RV1(end,3),'r.','MarkerSize',40)
    grid on
    axis equal
    
    set(gca, 'FontName', 'Helvetica','FontSize',12)
    set(gca,'YDir','normal')
    xlabel('X (Earth Radii)')
    ylabel('Y (Earth Radii)')
    zlabel('Z (Earth Radii)')
    title('Minimum \Delta V Transfers')
    legend({['Selected Min' char(10),'\Delta V=',num2str(EFM(y2,x2)),' km/s'],...
        ['EFM Global Min' char(10),'\Delta V=',num2str(EFM(ind(1),ind(2))),' km/s']},'Location','SouthEast')
    
%     % Plot Earth
%     colormap(topomap1);
%     [x,y,z]                        = sphere(50);
%     props.AmbientStrength          = 0.1;
%     props.DiffuseStrength          = 1;
%     props.SpecularColorReflectance = .5;
%     props.SpecularExponent         = 20;
%     props.SpecularStrength         = 1;
%     props.FaceColor                = 'texture';
%     props.EdgeColor                = 'none';
%     props.FaceLighting             = 'phong';
%     props.Cdata                    = topo;
%     surface(x,y,z,props);
end

return