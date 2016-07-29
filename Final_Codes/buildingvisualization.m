%% Initilization
clear;
clf;
% change city name
city='Austin';
% change the path to point to the source directory
images_Dir = ['Z:\data\objectidentification\final_data\Selected_Images\Orthoimagery\' city '\'];
USGS_images=dir(images_Dir);
% loop through each image
for a=1:length(USGS_images)
    % Discard the unwanted images and only run for tif images
    if USGS_images(a).bytes>0 && (~isempty(strfind(USGS_images(a).name,'.tif')))
        img=USGS_images(a).name;
        % obtain the name of the image without extension
        img_ID=img(1:length(img)-4);
        img_File=[images_Dir,img];
        % obatin the name of mat file
        loadtitle=[img_ID '_buildingCell.mat'];
        % load the mat file
        building=load(loadtitle);
        % load the x coordinates
        x=building.building_cell(2:end,10);
        % load the y coordinates
        y=building.building_cell(2:end,11);
        % read the tif image
        I=imread(img_File);
        figure(1)
        % discard the alpha channel
        im=I(:,:,1:3);
        imshow(im);
        hold on;
        % loop through each polygon and use mapshow to visualize it
        for i=1:length(x)
            m=x{i,1};
            n=y{i,1};
            mapshow(m,n)
        end
        % flip the y axis to overlay usgs image and building annotations
        set(gca,'Ydir','reverse');
        hold off;
        % save and name the figure
        figureti=[img_ID '_building+USGS.jpg'];
        saveas(figure(1),figureti);
    end
end
