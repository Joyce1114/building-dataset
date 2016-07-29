%
% proessUSGS is a helper function. It is used in runLIDAR, runbuildings,
% and runroad. It is used to extract coordinate and size information from
% the USGS image so that the LIDAR and Shapefile data can be indexed to the
% grid of the USGS image.
%
%
function [I,res,grid_length,grid_width,lat0,lat1,lon0,lon1] = processUSGS(img_File)        

 % tiff image is read. I is the image, and data is a struct with cartographic information 
 % stored about the image.
 [I, data] = geotiffread(img_File);
        
 % gridSize has the size of the image stored as [length, width].
  gridSize = data.RasterSize;
  
 % res is a parameter defining the resolution of the image.
  res = data.CellExtentInWorldX;
  
 % xLimits has information on the longitude boundaries of the image.
  xLimits = data.XWorldLimits;
  
 % yLimits has information on the latitude boundaries of the image.
  yLimits = data.YWorldLimits;
       
 % grid_length = length of orthoimage pixel array (used to interpolate lidar)
 % grid_width = width of orthoimage pixel array
  grid_length = gridSize(1);
  grid_width = gridSize(2);
  
 % lat0: latitude of most northern region of image
 % lat1: latitude of most southern region of image
 % lon0: longitude of most western region of image
 % lon1: longitude of most eastern region of image
  lat0 = yLimits(2);
  lat1 = yLimits(1);
  lon0 = xLimits(1);
  lon1 = xLimits(2);
end