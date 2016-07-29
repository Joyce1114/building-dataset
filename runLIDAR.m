% runLIDAR is a function which is a script to process height data. This
% script uses both the orthoimagery and the Lidar text file to create a
% matrix with height values, the same size as the orthoimage.

%% Initialization 
clear; 
format long e


%% Values to change for saving data

% Make this value 1 if you want to save height information as a mat file.
saveHeight = 1;


%% Processing USGS Image

% Change img_Dir to the path to the directory orthoimages are located.
img_Dir = 'Z:\data\objectidentification\FigShare\Images\';
% usgs_images is a list of the contents in the img_Dir directory.
usgs_images = dir(img_Dir);

% Loops through each image in the file. 
for y = 1:length(usgs_images)


    polygonID = 0;    
    
    % If the file has 0 bytes, will be a folder or is irrelevant as it is not
    % an image.
  if usgs_images(y).bytes>0
        
        
        % Image numbering convention corresponds to how LIDAR file and 
        % shapefile is also indexed. 
        % ex) img: 'city_01.tif'
        img = usgs_images(y).name; 
        

        % img_ID holds the name of the file without extension, used to 
        % reference other files.
        % ex) img_ID: 'city_01'
        img_ID = img(1:length(img)-4);
        
        % img_File is the path to the exact USGS image file inside of the
        % image directory
        % ex) 'path_to_image_directory/city_01.tif'
        img_File = [img_Dir img]; 
        
      
        % Calls processUSGS, a helper function with following input and
        % output:
        % Input: img_File (above)
        % Output:
        % I = image (RGB)
        % res = resolution of image
        % grid_length = length of orthoimage pixel array (used to interpolate lidar)
        % grid_width = width of orthoimage pixel array
        % lat0: latitude of most northern region of image
        % lat1: latitude of most southern region of image
        % lon0: longitude of most western region of image
        % lon1: longitude of most eastern region of image
        % 
        [I,res,grid_length,grid_width,lat0,lat1,lon0,lon1] = processUSGS(img_File);

       
        
%% Processing LIDAR Data (still in loop, and in if)

        % Change lidar_dir to the path to the directory in which lidar text
        % files are saved.
        lidar_dir ='Z:\data\objectidentification\final_data\Selected_Images\Lidar\'; 
        
        % Lidar text files are saved in the format of img(id
        % number)_text.txt inside of the lidar directory lidar_dir
        %ex) lidar : 'img001_text.txt'
        lidar = [img_ID '_lidar.txt']; 
        
        % lidar_File is the path to the exact lidar text file inside of the
        % lidar file directory
        % ex) lidar_File: 'path_to_lidar_directory/city01.txt'
        lidar_File = [lidar_dir lidar]; 
        
        % Calls a helper function proessLIDAR that returns an array of the
        % same sizme as 1 band in the USGS image. This array has the height
        % at the location stored, using the nearest interpolation method.
        % More detail can be found in the helper function file.
        Zheight = processLIDAR(lidar_File,grid_width,grid_length,lat0,lat1,lon0,lon1);
        
        % If saveHeight saved to 1, height matrix is saved to a matfile
        % that is indexed by the img_ID:
        % ex) city_01_height.mat
        if saveHeight
            Zheight_title = [img_ID '_height.mat'];
             save(Zheight_title,'Zheight');
        end
  end
end