
% Plot the Earth
if setplot == 1
    figure(1)
    load('topo.mat','topo','topomap1');
    whos topo topomap1
    colormap(topomap1);
    
    % Create the surface.
    [x,y,z] = sphere(50);
    props.AmbientStrength = 0.1;
    props.DiffuseStrength = 1;
    props.SpecularColorReflectance = .5;
    props.SpecularExponent = 20;
    props.SpecularStrength = 1;
    props.FaceColor= 'texture';
    props.EdgeColor = 'none';
    props.FaceLighting = 'phong';
    props.Cdata = topo;
    figure(1)
    surface(x,y,z,props);
    % set(gca,'color','black')
    % set(gcf,'color','black')
    
    % Add lights.
    % light('position',[-1 0 1]);
    % light('position',[-1.5 0.5 -0.5], 'color', [.6 .2 .2]);
    
end