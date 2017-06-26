clear;

% Read round.png
RGB = imread('round.png');

% Convert to grayscale and black and white images
I = rgb2gray(RGB);
bw = imbinarize(I);

% Remove small objects < 30px from B&W image
bw = bwareaopen(bw, 30);

% Create morphological structuring element and close the image
se = strel('disk', 2);
bw = imclose(bw, se);

% Fill image holes
bw = imfill(bw, 'holes');

% Trace the boundaries in the image
[B, L] = bwboundaries(bw, 'noholes');

% Display the image
imshow(label2rgb(L, @lines, [.25 .25 .25]));

hold on;

% Get image properties
stats = regionprops(L, 'Area', 'Centroid');

threshold = 0.9;

% Iterate through each object defined by the boundaries
for k = 1:length(B)
    boundary = B{k};
    
    % Draw boundaries on image
    plot(boundary(:, 2), boundary(:, 1), 'w', 'LineWidth', 2);
    
    % Find delta squared, perimeter and area
    delta_sq = diff(boundary).^2;
    perimeter = sum(sqrt(sum(delta_sq, 2)));
    area = stats(k).Area;
    
    % Determine shape roundness
    metric = 4*pi*area/perimeter^2;
    
    % Define roundness string
    metric_string = sprintf('%1.2f', metric);
    
    % Draw centroid if shape is round
    if metric > threshold
        centroid = stats(k).Centroid;
        plot(centroid(1), centroid(2), 'ko');
    end
    
    % Draw roundness text next to object
    text(boundary(1, 2) - 35, boundary(1, 1) + 13, metric_string, 'Color', 'y', ...
        'FontSize', 14, 'FontWeight', 'bold');
end

title('Round Objects');
