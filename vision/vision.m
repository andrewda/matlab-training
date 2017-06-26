img = imread('image.png');

subplot(2,1,1);
imshow(img);
title('Normal RGB');

subplot(2,1,2);
blue_img = double(img);
blue_img(:,:,3) = 4*blue_img(:,:,3);
blue_img = uint8(blue_img);
imshow(blue_img);
title('RG 4*B');