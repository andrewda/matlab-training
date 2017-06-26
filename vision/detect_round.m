clear;

RGB = imread('round.png');

I = rgb2gray(RGB);
bw = imbinarize(I);

bw = bwareaopen(bw, 30);

se = strel('disk', 2);
bw = imclose(bw, se);

bw = imfill(bw, 'holes');

[B, L] = bwboundaries(bw, 'noholes');

imshow(label2rgb(L, @lines, [.25 .25 .25]));

hold on;

stats = regionprops(L, 'Area', 'Centroid');

threshold = 0.9;

for k = 1:length(B)
    boundary = B{k};
    
    plot(boundary(:, 2), boundary(:, 1), 'w', 'LineWidth', 2);
    
    delta_sq = diff(boundary).^2;
    perimeter = sum(sqrt(sum(delta_sq, 2)));
        
    area = stats(k).Area;
    
    metric = 4*pi*area/perimeter^2;
    
    metric_string = sprintf('%1.2f', metric);
    
    if metric > threshold
        centroid = stats(k).Centroid;
        plot(centroid(1), centroid(2), 'ko');
    end
    
    text(boundary(1, 2) - 35, boundary(1, 1) + 13, metric_string, 'Color', 'y', ...
        'FontSize', 14, 'FontWeight', 'bold');
end

title('Round Objects');
