%% Intialization
clear;
clf;
% change the path to point to the correct folder
building_Dir = 'Z:\data\objectidentification\FigShare_copy\Cities\Norfolk\Buildings\Norfolk_03_buildingCell';

% load the road matfile
building=load(building_Dir);


% load the x coordinates of polylines
x=building.building_cell(2:end,10);
% load the y coordinates of polylines
y=building.building_cell(2:end,11);
% read the tif image
img_File = 'Z:\data\objectidentification\FigShare_copy\Cities\Norfolk\Images\Norfolk_03.tif';
I=imread(img_File);
figure(1)
% discard the alpha channel
im=I(:,:,1:3);
imshow(im);
hold on;
% loop each polyline and mapshow it
for i=1:length(x)
    m=x{i,1};
    n=y{i,1};
    mapshow(m,n)
end
% flip the y axis to overlay usgs image and building annotations
set(gca,'Ydir','reverse');
hold off;
% save and name the figure
figureti=['Norfolk_03_FigShare_building+USGS.jpg'];
saveas(figure(1),figureti);

    

