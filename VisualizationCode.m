% This code can be used to visualize orthoimagery, lidar, and shapefile
% (buildings or roads) data that has been downloaded. Visualizations can be
% of one data type or a combination. User must enter in in the "User Input"
% section the directories of their files and the visualization they want in
% the "Visualization" parameter. 



%% Intialization
clear;

%% User Input
% Change the City and Image_Name (City_#) to the one desired
City = 'Norfolk';
Image_Name = 'Norfolk_01';

% Change cities_dir to the path of the directory containing file for
% Cities.
cities_Dir = 'Z:\data\objectidentification\FigShare_copy';


% Change following folders (img_Dir: to high resolution orthoimagery and
% building_Dir: to cropped shapefile) if need be changed. Does not need
% to be changed if downloaded in same file order.
img_File = [cities_Dir '\Cities\' City '\Images\' Image_Name '.tif'];
lidar_File = [cities_Dir '\Cities\' City '\Heights\' Image_Name '_height'];
building_File = [cities_Dir '\Cities\' City '\Buildings\' Image_Name '_buildingCell'];
road_File = [cities_Dir '\Cities\' City '\Roads\' Image_Name '_road_cell'];

% Choose the visualization by entering into Visualization the string the
% specifies the image types to view. Choose from the following options and
% enter in exactly.
% Image: view high resolution orthoimagery.
% Lidar: view LIDAR (rasterized interpolated).
% Buildings: view shapefile for building polygons.
% Roads: view shapefile for road polylines.
% Image_Buildings_Roads: view building and road shapefiles overlayed onto high resolution
%   orthoimagery.
% Lidar_Buildings_Roads: view shapefile overlayed onto lidar.
Visualization = '';


%% Producing Specified Images
% Visualization produced depends on user's input in Visualization
% parameter.
switch Visualization
    
    % Case: showing the high resolution orthoimagery, without 4th channel
    case 'Image'
        Orthoimg = imread(img_File);
        Orthoimg = Orthoimg(:,:,1:3);
        FigTitle = [Image_Name ' Orthoimagery'];
        
        figure
        clf
        imshow(Orthoimg)
        title(FigTitle,'interpreter','none');
        
        % Case: showing rasterized interpolated LIDAR points in parula
        % colormap. Uses median and standard deviation as the axes, but
        % this can be adjusted manually if wanted by changing values in
        % range.
    case 'Lidar'
        load(lidar_File);
        med = median(Zheight(:));
        sd = std(Zheight(:));
        FigTitle = [Image_Name ' Lidar'];
        
        figure
        clf
        imshow(Zheight)
        colormap parula
        range = [med-2*sd med+2*sd];
        caxis(range)
        title(FigTitle,'interpreter','none')
        
        
        % Case: showing building polygon outlines from Open Street Map.
        % Polygons are created in Red. 
    case 'Buildings'
        load(building_File);
        xVals = building_cell(2:end,10);
        yVals = building_cell(2:end,11);
        
        figure
        clf
        hold on;
        for i=1:length(xVals)
            m=xVals{i,1};
            n=yVals{i,1};
            mapshow(m,n)
        end
        set(gca,'Ydir','reverse');
        hold off;
        FigTitle = [Image_Name ' Buildings']; 
        title(FigTitle,'interpreter','none') 
        axis off
        
        % Case showing roads polyline outlines from Open Street Map.
        % Polylines are created in blue.
    case 'Roads'
        load(road_File);
        xVals = road_cell(2:end,6);
        yVals = road_cell(2:end,7);
        
        figure
        clf
        hold on;
        for i=1:length(xVals)
            m=xVals{i,1};
            n=yVals{i,1};
            mapshow(m,n)
        end
        set(gca,'Ydir','reverse');
        hold off;
        FigTitle = [Image_Name ' Roads']; 
        title(FigTitle,'interpreter','none')   
        axis off
        
        % Case: Overlayed images- orthoimagery, building outlines in red,
        % and road outlines in blue.
    case 'Image_Buildings_Roads'
        Orthoimg = imread(img_File);
        Orthoimg = Orthoimg(:,:,1:3);
        
        load(road_File);
        xRoad = road_cell(2:end,6);
        yRoad = road_cell(2:end,7);
        
        load(building_File);
        xBuild = building_cell(2:end,10);
        yBuild = building_cell(2:end,11);
        
        
        FigTitle = [Image_Name ' Orthoimagery Buildings Roads'];
        
        figure
        clf
        imshow(Orthoimg)
        hold on;
        for i=1:length(xRoad)
            m=xRoad{i,1};
            n=yRoad{i,1};
            mapshow(m,n,'Color','blue')
        end
        set(gca,'Ydir','reverse');
        
        for i=1:length(xBuild)
            m=xBuild{i,1};
            n=yBuild{i,1};
            mapshow(m,n,'Color','red')
        end
        set(gca,'Ydir','reverse');
        hold off;
        
        title(FigTitle,'interpreter','none')
     
        
        % Case: Overlayed images- lidar, building outlines in red,
        % and road outlines in blue. Rasterized interpolated LIDAR points in parula
        % colormap. Uses median and standard deviation as the axes, but
        % this can be adjusted manually if wanted by changing values in
        % range.   
    case 'Lidar_Buildings_Roads'
        load(lidar_File);
        med = median(Zheight(:));
        sd = std(Zheight(:));
        
        load(road_File);
        xRoad = road_cell(2:end,6);
        yRoad = road_cell(2:end,7);
        
        load(building_File);
        xBuild = building_cell(2:end,10);
        yBuild = building_cell(2:end,11);
        
        
        FigTitle = [Image_Name ' Lidar Buildings Roads'];
        
        figure
        clf
        imshow(Zheight)
        colormap parula
        range = [med-2*sd med+2*sd];
        caxis(range)
        hold on;
        for i=1:length(xRoad)
            m=xRoad{i,1};
            n=yRoad{i,1};
            mapshow(m,n,'Color','blue')
        end
        set(gca,'Ydir','reverse');
        
        for i=1:length(xBuild)
            m=xBuild{i,1};
            n=yBuild{i,1};
            mapshow(m,n,'Color','red')
        end
        set(gca,'Ydir','reverse');
        hold off;
        
        title(FigTitle,'interpreter','none')

end

        
        
        
        
        
        
