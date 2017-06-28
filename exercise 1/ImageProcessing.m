images = dir('../../images/*.bmp');

% Iterate through images in the ../../images directory
for i = 1:numel(images)
    % Read the image and convert it to grayscale
    image = imread(strcat('../../images/', images(i).name));
    image = rgb2gray(image);

    % Threshold the image
    image_thresholded = image;
    image_thresholded(image < 100) = 0;
    
    % Write the image to ../new_images/filename.jpg
    split = strsplit(images(i).name, '.');
    path = sprintf('../new_images/%s.jpg', split{1});
    imwrite(image_thresholded, path, 'jpg');
end
