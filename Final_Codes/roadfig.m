%% Initialization
clear;
clf
% change the path to point to the correct directory
road_Dir = 'Z:\data\objectidentification\FigShare_copy\Cities\Norfolk\Roads\Norfolk_03_road_cell';

% load the road matfile
road=load(road_Dir);


% load the x coordinates of polylines
x=road.road_cell(2:end,6);
% load the y coordinates of polylines
y=road.road_cell(2:end,7);
% change the path to point to the wanted USGS image file
img_File = 'Z:\data\objectidentification\FigShare_copy\Cities\Norfolk\Images\Norfolk_03.tif';
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
% flip y axis to overlay USGS image and road annotations
set(gca,'Ydir','reverse');
hold off;
% name the figure and save it
figureti=['Norfolk_03_FigShare_road+USGS.jpg'];
saveas(figure(1),figureti);



