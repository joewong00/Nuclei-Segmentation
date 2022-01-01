%% Initial
clear
clc
close all

%% Image Reading==========================================================
im1 = imread("images/StackNinja1.bmp");
im2 = imread("images/StackNinja2.bmp");
im3 = imread("images/StackNinja3.bmp");

% Original image showing
figure; imshow(im1); title("Image 1")
figure; imshow(im2); title("Image 2")
figure; imshow(im3); title("Image 3")
fprintf('Program paused, click to continue...\n');
pause;

%% Image 1 Nuclei Counting=================================================
[out, nr, config] = solution(im1);
fprintf('The amount of nuclei found in image 1 is %d\n', nr);
fprintf('More info on nuclei config for this image is in "config" variable\n');
fprintf('Program paused, click to continue...\n');
pause;


%% Image 2 Nuclei Counting=================================================
close all

[out, nr, config] = solution(im2);
fprintf('The amount of nuclei found in image 2 is %d\n', nr);
fprintf('More info on nuclei config for this image is in "config" variable\n');
fprintf('Program paused, click to continue...\n');
pause;


%% Image 3 Nuclei Counting=================================================
close all

[out, nr, config] = solution(im3);
fprintf('The amount of nuclei found in image 3 is %d\n', nr);
fprintf('More info on nuclei config for this image is in "config" variable\n');
fprintf('End of run.\n');


