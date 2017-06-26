clear;

I = im2double(imread('image.png'));

gray = rgb2gray(I);

resized = imresize(gray, 0.5);

imshow(resized);
