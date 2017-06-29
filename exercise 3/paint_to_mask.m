paints = dir('./whitening/*_masktmp.bmp');

% Iterate through painted images
for i = 1:numel(paints)
    % Read image
    paint = imread(strcat(paints(i).folder, '/', paints(i).name));
    
    % Convert image to grayscale
    gray = rgb2gray(paint);
    
    % Find pixels containing bird signals (blue)
    bird_pixels = find(paint(:, :, 3) > 1);
    gray(bird_pixels) = 255;
    
    % Find pixels containing rain (yellow)
    rain_pixels = find(paint(:, :, 2) > 1);
    gray(rain_pixels) = 100;
    
    % Find pixels containing background (black)
    % This is probably not needed as it's just setting black pixels to
    % black, but I kept the code incase the color changes in the future.
    background_pixels = find(paint(:, :, 1) == 0 & ...
                             paint(:, :, 2) == 0 & ...
                             paint(:, :, 3) == 0);
    gray(background_pixels) = 0;
    
    % Write image as bitmap
    path = strcat('./masks/', paints(i).name);
    imwrite(gray, path, 'bmp');
end
