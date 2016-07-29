%% This is a helper function to convert latitude and longitude to pixel indices
% This function uses a linear transformation method
function pixel = coord2pix(curr,l0,l1,b,a)
% curr is the latitude/longitude
% l0 is the minimum latitude/longitude
% l1 is the maximum latitude/longitude
% b is the length/width of pixel grid
% a is the starting pixel indice
pixel = (curr - l0)*((b-a)/(l1-l0)) + a; 

end