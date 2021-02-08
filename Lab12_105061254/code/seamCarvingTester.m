%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script tests your implementation of seamCarving function, and you can 
% also use it for resizing your own images.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Clear all
clear; close all; clc;

%% Load data
image = imread('../data/bad/gate.jpg');
sz = size(image);
% resize image to half size
%image = imresize(image, [floor(sz(1)/3), floor(sz(2)/3)]);
image = imresize(image, [floor(sz(1)/6), floor(sz(2)/6)]); %for lake
sz = size(image);
figure
imshow(image)
imwrite(image, '../results/gate.jpg', 'quality', 95);

%% Image resizing
% apply seam carving reduce
image_seamCarving_reduce = seamCarvingReduce(double(image), floor(sz(2)/2), 1);
figure
imshow(uint8(image_seamCarving_reduce));
imwrite(uint8(image_seamCarving_reduce), '../results/gate_seam.jpg', 'quality', 95);

% seam carving horizontal
image_seamCarving_reduce_horizontal = seamCarvingReduce(double(image), floor(sz(1)/2), 0);
figure
imshow(uint8(image_seamCarving_reduce_horizontal));
imwrite(uint8(image_seamCarving_reduce_horizontal), '../results/gate_seam_horizontal.jpg', 'quality', 95);

% apply scaling 
image_scaling_width = imresize(image, [sz(1), floor(sz(2)/2)]);
figure
imshow(image_scaling_width);
imwrite(image_scaling_width, '../results/gate_scale.jpg', 'quality', 95);

% apply cropping 
image_crop_width = imcrop(image, [1, 1, floor(sz(2)/2), sz(1)]);
figure
imshow(image_crop_width);
imwrite(image_crop_width, '../results/gate_crop.jpg', 'quality', 95);
