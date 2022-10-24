
% Plot Initial and Final position
if setplot == 1
    figure(1)
    hold on
    plot3(DepOrbit(xx,1),DepOrbit(xx,2),DepOrbit(xx,3),'k.','MarkerSize',25)
    plot3(r1(1),r1(2),r1(3),'k.','MarkerSize',20)
    plot3(r2(1),r2(2),r2(3),'r.','MarkerSize',20)
end

colors  = {'b-','r-','g-','m-','c-','y-','k-',...
            'b--','r--','g--','m--','c--','y--',...
            'b-.','r-.','g-.','m-.','c-.','y-.'};         % Colors for plots