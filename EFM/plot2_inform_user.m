
% Plot the transfer trajectory
if setplot == 1
    if Ecol == 0 && EscVel == 0 && max(abs(r2-FnG_OUT(end,1:3))) < tol
        figure(1)
        plot3(r2(1),r2(2),r2(3),'g.','MarkerSize',30)
        plot3(FnG_OUT(:,1),FnG_OUT(:,2),FnG_OUT(:,3),colors{ncnt},'MarkerSize',1,'DisplayName',tmp)
        plot3(FnG_OUT(:,1),FnG_OUT(:,2),FnG_OUT(:,3),colors{ncnt},'DisplayName',tmp)
    end
    xlabel('DU (Earth Radii)')
    ylabel('DU (Earth Radii)')
    zlabel('DU (Earth Radii)')
    
    pause(0.5);
end