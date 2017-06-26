clear;

% Read image.png
I = imread('image2.png');

% Display image
imshow(I);

% Get two mouse clicks, top left and bottom right
[X,Y] = ginput(2);

% Crop image to within those boundaries
C = imcrop(I, [min(X) min(Y) abs(diff(X)) abs(diff(Y))]);

% Get new and original sizes
orig_size = size(I);
new_size = size(C);

% Calculate new and original areas
orig_area = orig_size(1) * orig_size(2);
new_area = new_size(1) * new_size(2);

% Calculate the appropriate scale
scale = sqrt(orig_area/new_area);

% Scale image so that area of final matches original
C = imresize(C, scale);

% Display final image
imshow(C);
