
% Indices for plotting purposes
indD     = find(DepTime <= DepP);
indD     = indD(end);
if indD == length(DepTime)
    indD = length(DepTime)-1;
end
indA     = find(ArrTimeO <= ArrP);
indA     = indA(end);

% Plot reference orbits
if setplot == 1
    figure(1)
    hold on
    grid on
    plot3(0,0,0,'k.','MarkerSize',30)
    plot3(DepOrbit(1:indD+1,1),DepOrbit(1:indD+1,2),DepOrbit(1:indD+1,3),'k-','Linewidth',3)
    plot3(ArrOrbit(1:indA+1,1),ArrOrbit(1:indA+1,2),ArrOrbit(1:indA+1,3),'k--','Linewidth',3)
    axis equal
    %     set(gca,'color','black')
    %     set(gcf,'color','black')
end