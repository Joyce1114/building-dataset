% roadvisulization.m ------------------------------------------------------------
%
%This script overlays USGS images and building annotations so that people
%can visualize them
% Author: Joyce Xi, Ben Brigman, Sophia Park
% Organization: Duke University, Data+

%% Intialization
clear;
clf;
% Change the path to point to the source file
images_Dir = 'Z:\data\objectidentification\FigShare_copy\Cities\';
% run all the cities
allCities = dir(images_Dir);
for b=1:length(allCities)
    city=allCities(b).name;
    % discard unwanted files
    if any(isstrprop(city,'alpha'))
        % change the path to point to the city folder
        img_Dir=['Z:\data\objectidentification\FigShare_copy\Cities\' city '\Images\'];
        USGS_images=dir(img_Dir);
        for a=1:length(USGS_images)
            % discard the emtpy USGS images
            if USGS_images(a).bytes>0 && (~isempty(strfind(USGS_images(a).name,'.tif')))
                img=USGS_images(a).name;
                % obatin the image id of the USGS image without extension
                img_ID=img(1:length(img)-4);
                img_File=[img_Dir,img];
                loadtitle=[img_ID '_road_cell.mat'];
                % load the road matfile
                loadfile = ['Z:\data\objectidentification\FigShare_copy\Cities\' city '\Roads\' loadtitle ];
                road=load(loadfile);
                % load the x coordinates of polylines
                x=road.road_cell(2:end,6);
                % load the y coordinates of polylines
                y=road.road_cell(2:end,7);
                % read the tif image
                I=imread(img_File);
                figure(1)
                % ignore the alpha channel
                im=I(:,:,1:3);
                imshow(im);
                hold on;
                % loop each polyline and mapshow it
                for i=1:length(x)
                    m=x{i,1};
                    n=y{i,1};
                    mapshow(m,n)
                end
                % flip the y axis to overlap USGS images and building annotations
                set(gca,'Ydir','reverse');
                hold off;
                % title the figure
                figureti=[img_ID '_road.jpg'];
                % save figure
                saveas(figure(1),figureti);
            end
        end
    end
end
