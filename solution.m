function [out, nr, config] = solution(im_in)

%% Bw Image
% Take second slice (green slice)
im_2nd = im_in(:,:,2);
figure, imshow(im_2nd);title('Second Slice of Input Image');

% Increase contrast and sharpen the image
im_sharpen = imsharpen(imadjust(im_2nd));
figure, imshow(im_sharpen);title('Sharpened and Adjusted Image');

% Apply median filter to remove noise
im_filt = medfilt2(im_sharpen);
figure, imshow(im_filt);title('Median Filtered Image');

% Apply top and bottom hat filter
se1 = strel('disk',10);
im_filt_top = imtophat(im_filt,se1);
im_filt_bot = imbothat(im_filt,se1);
im_btfilt = im_filt + im_filt_top - im_filt_bot;
figure, imshow(im_btfilt);title('Apply Top and Bottom Hat Filter');

% Convert to BW image with adaptive threshold
im_bw = imbinarize(im_btfilt,'adaptive');
figure, imshow(im_bw);title('Binarized Image with Adaptive Threshold');

% Remove noise on cell wall region, then subtract
im_bwnew = im_bw - imbinarize(medfilt2(im_in(:,:,1))-im_btfilt);
im_bwnew(im_bwnew < 0) = 0;
im_bwnew = logical(im_bwnew);
figure, imshow(im_bwnew);title('Subtracting Cell Wall Region');

% Apply median filter to remove salt noise
im_bw_filt = medfilt2(im_bwnew);

% Apply erosion then dilation to emphasize on nuclei
se2 = strel('disk',2);
im_bw_filt = imopen(im_bw_filt,se2);
figure, imshow(im_bw_filt);title('Filtered and Processed Morphologically');


% Apply watershed algorithm to separate combined nuclei
d = -bwdist(~im_bw_filt);
figure, mesh(d); title('Distance Transformed Image');

d = imhmin(d,2);
im_nuclei = im_bw_filt;
L = watershed(d);
figure, imshow(L, []); title('Watershed Segmentation')

% Segment image
im_nuclei(L == 0) = 0;

% fill in the holes of the nuclei and as output image
out = imfill(im_nuclei, 'hole');

figure,imshow(out); title('Output Image');
figure,imshow(im_in*0.8 + uint8(out * 255)*0.7); title('Output Image with Overlay');

%% Nuclei Counting
% Label image and number of objects
[out, nr] = bwlabel(out);

%% Size 
% Calculate areas of nucleus
statarea = regionprops(out, 'area');

% Distribution
config.areas.dist = [statarea.Area];
figure, bar(config.areas.dist);title('Nucleus Size Disributions');

% Statistics
config.areas.max = max(config.areas.dist);
config.areas.min = min(config.areas.dist);
config.areas.avg = mean(config.areas.dist);

%% Shapes
% Find shapes of nucleus

statshape1 = regionprops(out,'Circularity');
config.shapes.circularity = [statshape1.Circularity];

statshape2 = regionprops('table',out,'Centroid',...
    'MajorAxisLength','MinorAxisLength');

% Get center and radius
centers = statshape2.Centroid;
diameters = mean([statshape2.MajorAxisLength statshape2.MinorAxisLength],2);
radii = diameters/2;

% Plot circle
figure, imshow(out);title('Nuclei in Circles');
hold on;
viscircles(centers,radii);
hold off;

config.shapes.centers = centers;
config.shapes.radii = radii;


%% Brightness
% Get pixel index in the label image
statbright = regionprops(out,'PixelIdxList');

% Total number of nuclei
n = length(statbright);

brightness = zeros(n);

% for each nucleus, get the pixel index and find pixel value
for i = 1:n
    
    nucleus = im_2nd([statbright(i).PixelIdxList])';
    brightness(i,1:length(nucleus)) = nucleus; 
    
end

% Row average value (excluding zero) 
avgbrightness = sum(brightness,2)./sum(brightness~=0,2);
figure,bar(avgbrightness);title('Nucleus Brightness Disributions');

% Statistics
config.brightness.dist = avgbrightness;
config.brightness.avg = mean(avgbrightness);
config.brightness.max = max(avgbrightness);
config.brightness.min = min(avgbrightness);

end

