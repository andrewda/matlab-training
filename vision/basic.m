clear;

% Read image.png and convert to double
I = im2double(imread('image.png'));

% Convert image to grayscale
gray = rgb2gray(I);

% Resize to 50%
resized = imresize(gray, 0.5);

% Show the image
imshow(resized);
