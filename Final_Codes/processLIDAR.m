%
% processLIDAR is a helper function to extract the important information, a grid
% with heights, from the LIDAR. It uses the method of nearest neighbor
% interpolation in order to make from nonuniformly distributed
% LIDAR points a rasterized grid of height values.
%
% Input: 
% lidar_File: This is a string of the exact location of the Lidar text File
% including the path to its directory.
% grid_width: This is the width of the USGS image, from the output of
% processUSGS. 
% grid_length: This is the length of the USGS image, also from the output
% of processUSGS.
% lat0: latitude of most northern region of image
% lat1: latitude of most southern region of image
% lon0: longitude of most western region of image
% lon1: longitude of most eastern region of image
% 
% Output:
% Zheight: This is a matrix which is the same size as the USGS image, and
% in which the indices of the matrix match up with the indices of the USGS
% image.
%






function Zheight = processLIDAR(lidar_File,grid_width,grid_length,lat0,lat1,lon0,lon1)        

    % Lidar text file is read into A. The columns of A are divided into
    % x-values, y-values, and z-values. Each of these columns are divided
    % into vectors so that x contains all the x-values, y contains the
    % y values and height contains the z values of a corresponding point. 
    %
        A=importdata(lidar_File); 
        x=A(:,1); 
        y=A(:,2); 
        height=A(:,3); 
        
    % The column vectors are all transposed to be row vectors.
        xrow=x'; 
        yrow=y'; 
        heightrow=height'; 

    % xRange is a vector which starts from the longitude of the most
    % western boundary of the image to the longitude of the most eastern
    % boundary of the image, and is length of the width of the USGS image.
        xRange=linspace(lon0,lon1, grid_width); 
        
    % yRange is a vector which starts from the latitude of the most
    % northern boundary of the image to the latitude of the most southern
    % boundary of the image, and is the length of the length of the USGS image.         
        yRange=linspace(lat0,lat1, grid_length); 
        
    % A grid is created from xRange and yRange to create a matrix of
    % coordinates of the USGS image, and is the same size as one channel of
    % the USGS image. 
        [XI,YI]=meshgrid(xRange,yRange);
        
    % Zheight fits data points for x based on the corresponding x and y
    % values into the surface grid created [XI,YI]. It uses nearest
    % neighbor interpollation so that each point in the grid has one point.
    % Because LIDAR data is fairly dense, nearest neighbor is a good option
    % for interpolation that supports 3d interpolation.
        Zheight=griddata(xrow,yrow,heightrow,XI,YI,'nearest');
end