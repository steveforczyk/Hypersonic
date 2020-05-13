function [axis_handle]=display_globe(opt)

%option can be "topo" or "outline"
% earth_picture_fn='C:\Documents and Settings\sedlacksn\Desktop\steve_matlab_stuff\globe\Earth_2048a.jpg';
earth_picture_fn='noaa_world_topo_bathymetric_lg.jpg';

%figure; hold all
% axis_handle=axesm('globe', 'Geoid',[6371000,0]);
% set(gcf,'Renderer','zbuffer');
% opengl('OpenGLBitmapZbufferBug',1);
%set(gcf,'color','k');
switch opt
    case 'topo'
        %         load topo
        %         meshm(topo, topolegend, size(topo)); demcmap(topo);
        earth_picture = imread(earth_picture_fn) ;
        for ii = 1:3
            earth_picture(:, :, ii) = flipud(earth_picture(:, :, ii)) ;
        end
        earth_picture = circshift(earth_picture, [0, 84, 0]) ;
        toposet = [1 90 175] ;
        mh=meshm(zeros(180, 360), toposet) ;
        setm(mh, 'MeshGrat', [180, 360]) ;
        set(mh, 'FaceColor', 'texturemap', 'CData', earth_picture) ;
        
        coastlines = shaperead('landareas',...
            'UseGeoCoords', true, 'Attributes', {});
        plotm([coastlines.Lat], [coastlines.Lon], 'Color', 'b')
    case 'outline'
        base=zeros(180,360);
        baseR=makerefmat('RasterSize', size(base),...
            'Latlim',[-90 90], 'Lonlim', [0 360]);
        meshm(base,baseR,size(base),'FaceColor','w');
        %colormap bone;
        coastlines = shaperead('landareas',...
            'UseGeoCoords', true, 'Attributes', {});
        plotm([coastlines.Lat], [coastlines.Lon], 'Color', 'b')
    otherwise
        fprintf('error - options are ''topo'' or ''outline''\n');
        return
end

gridm('GLineStyle','-','Gcolor','k','Galtitude', .002)

axis off
hold all
