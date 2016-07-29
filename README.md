# building-dataset
Automated object identification in high-resolution imagery can provide valuable information in fields ranging from urban planning to economic research.  The goal of the project is to determine the volume of a building from a high-resolution satellite image using computer vision algorithms. We have built a dataset comprising of satellite images including annotations of building footprints (OSM shapefiles) as well as data on the building heights (LIDAR). This dataset can be used as ground truth to train computer vision algorithms to determine a building’s volume from an image. The dataset is available in FigShare at https://dx.doi.org/10.6084/m9.figshare.c.3290519. This set of code processes geographic shapefiles and LIDAR into matlab readable .csv and .mat files.

Instructions for the codes:
To process height data, run runLIDAR.m which interpolates the LIDAR into a raster grid and saves the height values as a matrix
  1.	Helper functions needed to be downloaded:
    a.	processUSGS.m reads the information of the orthoimagery
    b.	processLIDAR.m rasterizes raw LIDAR to fit pixel grid in orthoimagery
  2.	Change the path to point to locations of orthoimagery and LIDAR (for more details, see comments in the code)
  
To process shapefile(buildings), run runbuildings.m which adds pixel coordinates for the vertices and saves the polygon information as a mat file and csv files
  1.	Helper functions needed to be downloaded:
    a.	processUSGS.m reads the information of the orthoimagery
    b.	coord2pix.m converts latitude and longitude to pixel indices
    c.	cell2csv.m converts a cell array to a csv file
  2.	Change the path to point to locations of orthoimagery and shapefile (for more details, see comments in the code)

To process shapefile(roads), run runroads.m which adds pixel coordinates for the vertices and saves the polyline information as a mat file and csv files
  1.	Helper functions needed to be downloaded:
    a.	coord2pix.m converts latitude and longitude to pixel indices
    b.	cell2csv.m converts a cell array to a csv file
  2.	Change the path to point to locations of orthoimagery and shapefile (for more details, see comments in the code)
  
To visualize output, run VisualizationCode.m which overlay different images
  1.	Change the path to point to correct locations of outputs (for more details, see comments in the code)

