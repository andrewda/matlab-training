clear;

% Read image.png
img = imread('image.png');

% Display normal image
subplot(2,1,1);
imshow(img);
title('Normal RGB');

% Display blue image
subplot(2,1,2);
blue_img = double(img);
blue_img(:,:,3) = 4*blue_img(:,:,3);
blue_img = uint8(blue_img);
imshow(blue_img);
title('RG 4*B');
