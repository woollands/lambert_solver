
% Plot the transfer trajectory
if fig == 1 && retro == 0
    if ncnt == 1
        figure(1)
        plot3(FnG_OUT(1,1),FnG_OUT(1,2),FnG_OUT(1,3),'b.','MarkerSize',20)
        hold on
        plot3(FnG_OUT(end,1),FnG_OUT(end,2),FnG_OUT(end,3),'r.','MarkerSize',20)
        grid on
    end
    if Ecol == 0 && EscVel == 0 && max(abs(r2-FnG_OUT(end,1:3))) < tol
        figure(1)
        plot3(FnG_OUT(:,1),FnG_OUT(:,2),FnG_OUT(:,3),colors{ncnt})
    end
    xlabel('DU (Earth Radii)')
    ylabel('DU (Earth Radii)')
    zlabel('DU (Earth Radii)')
    title('Prograde')
    legend('Start','End')
end

if fig == 1 && retro == 1
    if ncnt == 1
        figure(2)
        plot3(FnG_OUT(1,1),FnG_OUT(1,2),FnG_OUT(1,3),'b.','MarkerSize',20)
        hold on
        plot3(FnG_OUT(end,1),FnG_OUT(end,2),FnG_OUT(end,3),'r.','MarkerSize',20)
        grid on
    end
    if Ecol == 0 && EscVel == 0 && max(abs(r2-FnG_OUT(end,1:3))) < tol
        figure(2)
        plot3(FnG_OUT(:,1),FnG_OUT(:,2),FnG_OUT(:,3),colors{ncnt})
    end
    xlabel('DU (Earth Radii)')
    ylabel('DU (Earth Radii)')
    zlabel('DU (Earth Radii)')
    title('Retrograde')
    legend('Start','End')
end