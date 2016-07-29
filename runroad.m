% runroad.m ------------------------------------------------------------
%
%This script saves the information of roads in a matfile. It also saves the
%coordinates of vertices and other information in two separate csv files
%
% Author: Joyce Xi, Ben Brigman, Sophia Park
% Organization: Duke University, Data+

%% Initialization
clear;
% run all the cities
% change the path to direct to the source file
images_Dir = 'Z:\data\objectidentification\final_data\Selected_Images\Orthoimagery\';
allCities = dir(images_Dir);

for b = 1:length(allCities);
    % city is the name of each subfolder
    city = allCities(b).name;
    % to discard the empty files
    if any(isstrprop(city,'alpha'))
        
        % change the path to direct the source file
        img_Dir=['Z:\data\objectidentification\final_data\Selected_Images\Orthoimagery\' city '\'];
        USGS_images=dir(img_Dir);
        for a=1:length(USGS_images)
            % find .tif images
            if USGS_images(a).bytes>0 && (~isempty(strfind(USGS_images(a).name,'.tif')))
                img=USGS_images(a).name;
                % obtain the name of this image by deleting the .tif
                img_ID=img(1:length(img)-4);
                img_File=[img_Dir,img];
                shape_file = ['Z:\data\objectidentification\final_data\Selected_Images\OSM_Roads\' img_ID '_road.shp'];
                B=shaperead(shape_file);
                % assign the value of B to A and A is used to convert geographic
                % coordinates to pixel indices
                A=B;
                % use geotiffread function to process USGS image
                [image, data]=geotiffread(img_File);
                % grid_length = length of image pixel array (used to interpolate lidar)
                % grid_width = width of image pixel array
                % lat0: latitude of most northern region of image
                % lat1: latitude of most southern region of image
                % lon0: longitude of most western region of image
                % lon1: longitude of most eastern region of image
                xlimits=data.XWorldLimits;
                ylimits=data.YWorldLimits;
                lat0=ylimits(2);
                lat1=ylimits(1);
                lon0=xlimits(1);
                lon1=xlimits(2);
                gridsize=data.RasterSize;
                grid_width=gridsize(2);
                grid_length=gridsize(1);
                % intialize the road_cell array
                clear road_cell;
                road_cell=cell(length(B)+1,7);
                % name the fields in road_cell array
                road_cell(1,:)={'Image_Name','Polyline_ID','Road_Name','OSM_ID','Type','Road_X','Road_Y'};
                % Initialize road_coor_cell cell array
                clear road_coor_cell;
                % name the fields in road_coor_cell array
                % road_coor_cell contains the coordinages of vertices
                road_coor_cell(1,1:3)={'Image_Name','Polyline_ID','Number_Vertices'};
                % initialize the road_ID
                road_ID=0;
                parfor i=1:length(B)
                    Polyline_ID=i;
                    % read the X coordinates
                    shapeX=B(i).X;
                    % read the Y coordinates
                    shapeY=B(i).Y;
                    % read the osm_id of each polyline
                    OSM_ID=B(i).osm_id;
                    % read the name
                    Road_Name=B(i).name;
                    % read the type of road
                    Type=B(i).type;
                    % increment road_ID
                    road_ID=road_ID+1
                    % loop through each coordinate
                    for j=1:length(shapeX)
                        currX=shapeX(j);
                        currY=shapeY(j);
                        % skip the nan values
                        if ~isnan(currX)
                            % convert the coordinates
                            A(i).X(j)=coord2pix(currX,lon0,lon1,grid_width,1);
                            A(i).Y(j)=coord2pix(currY,lat0,lat1,grid_length,1);
                        end
                        
                    end
                    % write the values in road_cell array
                    road_cell(i+1,:)={img_ID,Polyline_ID,Road_Name,OSM_ID,Type,A(i).X,A(i).Y};
                end
                road_csv=road_cell(:,1:5);
                roadTitle=[img_ID '_road.csv'];
                % convert the first five column of road_cell array to csv file
                cell2csv(roadTitle,road_csv);
                
                %% The part below works on the coordinate csv file
                for q = 1:length(B)
                    % read the x coordinates from road_cell array
                    roadX = road_cell{q+1,6};
                    % read the y coordinates from road_cell array
                    roadY = road_cell{q+1,7};
                    for w = 1:length(roadX)
                        % coordinates are written as alternating x and y
                        % values
                        road_coor_cell(q+1,2*w+2) = {roadX(w)};
                        road_coor_cell(q+1,2*w+3) = {roadY(w)};
                    end
                    % load the coordinages from road_cell array to
                    % road_coor_cell array
                    road_coor_cell(q+1,1) = road_cell(q+1,1);
                    road_coor_cell(q+1,2) = road_cell(q+1,2);
                    road_coor_cell(q+1,3) = {length(roadX)};
                end
                % save the coordinate csv file
                roadcellTitle=[img_ID '_road_cell'];
                save(roadcellTitle,'road_cell');
                coordtitle=[img_ID '_roadCoord.csv'];
                cell2csv(coordtitle,road_coor_cell);
                
            end
        end
    end
end
