% runbuildings.m ------------------------------------------------------------
%
%This script saves all of the groundtruth data in a matrix for height that
%is the same size as 1 band of the RGB image. This is available in a .mat
%file, img_ID '_orthoimage_height.mat' where img_ID is the name of the
%image that was inputted. It also saves building polygon information in a
%.mat file, buildings.mat. This is for all images. This is available in
%.csv format as well without the polygon vertices.
%
% This code requires the following codes to be run: 
% coord2pix.m
% cell2csv.m
% processUSGS.m
% 
%
% Author: Joyce Xi, Ben Brigman, Sophia Park
% Organization: Duke University, Data+



%% Initialization
clear;
format long e


%% User Input
city = 'Austin';

% Make this value 1 if you want to save building information in csv and mat
% files
saveBuildings = 1;

% Change img_Dir to the path to the directory orthoimages are located
img_Dir = ['Z:\data\objectidentification\FigShare_copy\Cities\' City '\Images'];
% Change output_Dir to the desired directoy for output to be located
output_Dir = ['Z:\data\objectidentification\FigShare_copy\Cities\' City '\Buildings'];
% Change building_Dir to the directory in which cropped building shapefiles
% are located.
building_Dir = 'Z:\data\objectidentification\final_data\Selected_Images\OSM\';


usgs_images = dir(img_Dir);

% This code processes shapes for each image in the city specified. 
for y = 1:length(usgs_images)
    
    polygonID = 0;
    
    % If the file has 0 bytes, will be a folder or is unrelevant as it is not
    % an image.
    if usgs_images(y).bytes>0
        
        
        % Image numbering convention corresponds to how LIDAR file and
        %shapefile is indexed. Numbering does not hold significance, was
        % created by us.
        % ex) img: 'city_01.tif'
        img = usgs_images(y).name;
        
        
        % img_ID holds the name of the file without extension, used to reference other files.
        % ex) img_ID: 'city_01'
        img_ID = img(1:length(img)-4);
        
        % img_File is the path to the exact USGS image file inside of the
        % image directory
        % ex) 'path_to_image_directory/city_01.tif'
        img_File = [img_Dir img];
       
        % Calls processUSGS, a helper function that gives
        % I = image (RGB)
        % res = resolution of image
        % grid_length = length of image pixel array (used to interpolate lidar)
        % grid_width = width of image pixel array
        % lat0: latitude of most northern region of image
        % lat1: latitude of most southern region of image
        % lon0: longitude of most western region of image
        % lon1: longitude of most eastern region of image
        [I,res,grid_length,grid_width,lat0,lat1,lon0,lon1] = processUSGS(img_File);
        
        
        
        
        
        %% Processing each shape
        
        % For loop iterates through all of the polygons. Parallel for loop is used
        % to increase spead. Information is extracted about each polygon and saved
        % in building_cell, a cell array. Information that is stored in the cell
        % array:
        %
        %img_ID ('Image_Name'): image ID, numbering convention created by us from 1-n (n=number of
        %images), same ID used to refer to USGS and LIDAR files
        %
        % ('Polygon_ID'): polygon ID, numbering convention created by us. Does not
        %start over with each image, each building has unique polygon_ID.
        %
        %OSM_ID: ID for the building polygon, numbering convention created by Open Street
        %Map
        %
        %centroid_lat_pix: y_value for pixel index of centroid of building
        %
        %centroid_lon_pix: x_value for pixel index of centroid of building
        %
        %area_pix: Area inside building polygon in number of pixels.
        %
        %area_meter: Area inside building polygon in square meters.
        %
        %newX: X coordinates for pixel indices of building polygon vertices.
        %
        %newY: Y coordinates for pixel indices of building polygon vertices.
        
        
        shape_File = [building_Dir img_ID '_building.shp'];
        all_Shapes = shaperead(shape_File);
        
        % Copy all_shapes to A for converting the geographic coordinates to pixel
        % indices
        A=all_Shapes;
        
        % polygonID, row_poly are to iterate through and keep track of
        % which polygon (polygon indexing is unique for each image)
        polygonID = 0;
        row_poly = 1;
        
        % num_shapes is the number of polygons found in a given image
        num_shapes = length(all_Shapes);
        
        % Clear previous and initialize cell array with shape information
        clear building_cell;
        building_cell = cell(num_shapes+1, 11);
        
        
        % Define the fields in building_cell
        building_cell(1,:)={'Image_Name' 'Polygon_ID' 'OSM_ID' 'Centroid_X'...
            'Centroid_Y' 'Centroid_Longitude' 'Centroid_Latitude' 'Area_Pixels' 'Area_Meters'...
            'Polygon_X' 'Polygon_Y'};
        
        % Initialize cell array with vertices information
        clear polygon_cell;
        polygon_cell(1,1:3) = {'Image_Name','Polygon_ID','Number_Vertices'};
        
 
        
        parfor p = 1:length(all_Shapes)
            
            polygonID = p;
            
            % shapeX and shapeY hold the longitude and latitude coordinates
            % (respectfully) of vertices of the polygon.
            
            shapeX = all_Shapes(p).X;
            shapeY = all_Shapes(p).Y;
            
            % OSM_ID is extracted from original shapefile.
            OSM_ID = all_Shapes(p).OSM_ID;
            
            % centroid_lon and centroid_lat are the latitude and longitude
            % values in decimal degrees (NAD83) for the polygon from the
            % original shapefile.
            centroid_lon = all_Shapes(p).CENTROID_X;
            centroid_lat = all_Shapes(p).CENTROID_Y;
            
            % Helper function coord2pix is used with grid length and
            % coordinate information from the orthoimagery to convert the
            % vertex coordinates into vertex pixel indices. 
            centroid_x = coord2pix(centroid_lon,lon0,lon1,grid_width,1);
            centroid_y = coord2pix(centroid_lat,lat0,lat1,grid_length,1);
            
            % area_meter is the area in meter squared, from the original
            % shapefile. 
            area_meter = all_Shapes(p).POLY_AREA;
            
            % numNan holds the number of NAN values in the vertex
            % coordinates. NANs are significant but cannot be run as Matlab
            % function inputs.
            numNan=numel(find(isnan(shapeX)));
            numpoints=length(shapeX)-numNan;
            
            % newX and newY will hold the pixel values for the vertex
            % coordinates without the nan values. 
            newX=zeros(numpoints,1);
            newY=zeros(numpoints,1);
            
            counter=0;
            for i=1:length(shapeX)
                currX = shapeX(i);
                currY = shapeY(i);
                
                % Transformation from latitude longitude to pixel
                % coordinatesis done only if the value is not NAN.
                if ~isnan(currX)
                    
                    % To convert the latitude and lontitude to pixel
                    % coordinates with nan values. 
                    A(p).X(i) = coord2pix(currX, lon0,lon1,grid_width,1);
                    A(p).Y(i) = coord2pix(currY, lat0,lat1,grid_length,1);
                    
                    % Discard nan values for calculating the polygon
                    % area becuase poly2mask cannot read nan values
                    counter=counter+1;
                    newX(counter)= coord2pix(currX, lon0,lon1,grid_width,1);
                    newY(counter)= coord2pix(currY, lat0,lat1,grid_length,1);
                end
            end
            
            % Create mask for current building. Mask used to get region
            % properties.
            BW = poly2mask(newX,newY,grid_length,grid_width);
            props = regionprops(BW, 'Area','Centroid');
            
            % Check if area is a polygon. Could be just points, or a line (polygon not
            % closed). In this case, the area and centroid parameters are all 0. This
            % does not mean there is a polygon at (0,0), but is signifiying faulty
            % data.
            if ~isempty(props)
                area_pix = props.Area;
                
            else
                
                area_pix = 0;
                
            end
            
            
            % Information from shapefile is stored into cell array
            % building_cell.
            building_cell(p+row_poly,:) = {img_ID,polygonID, OSM_ID,centroid_x,centroid_y,...
                centroid_lon, centroid_lat,area_pix,area_meter,A(p).X,A(p).Y...
                };
        end

        
     %% Saving data
        
        % Saving the cell array into a .mat file and a csv file.
        if saveBuildings
            buildingCellTitle = [img_ID '_buildingCell'];
            save(buildingCellTitle,'building_cell');
            
            % Cell array with information about building except for 
            % coordinates of vertices saved as a cell array and then
            % generated into a .csv file.
            building_csv = building_cell(:,1:9);
            building_title = [img_ID '_buildings.csv'];
            cell2csv(building_title,building_csv);
           
            % Cell array for .csv file with only coordinate values.
            for q = 1:num_shapes
                
                % Getting the X and Y values from the original cell array.
                polyX = building_cell{q+1,10};
                polyY = building_cell{q+1,11};
                
                for w = 1:length(polyX)
                    % Coordinates are written as alternating x and y values
                    polygon_cell(q+1,2*w+2) = {polyX(w)};
                    polygon_cell(q+1,2*w+3) = {polyY(w)};
                end
                
                % polygon_cell also stores image number(column 1),
                % polygon_ID (2), and the number of vertices in the
                % polygon.
                polygon_cell(q+1,1) = building_cell(q+1,1);
                polygon_cell(q+1,2) = building_cell(q+1,2);
                polygon_cell(q+1,3) = {length(polyX)};
                
            end
            
            % Cell array with only coordinates generated into .csv file
            polygon_title = [img_ID '_buildingCoord.csv'];
            cell2csv(polygon_title,polygon_cell);
            
            % All files are moved to the output directory specified by user.
            movefile(polygon_title, output_Dir);
            movefile(building_title,output_Dir);
            movefile(buildingCellTitle,output_Dir);
        end
        
    end
end

