close all;
clear;
clc;

%% for image 1
% read image
filename = '../image.jpg';
I = imread(filename);
figure('name', 'source image');
imshow(I);

%% ----- call functions ----- %%
% output = function(input1, input2, ...);
% grey_scale function
I2 = grey_scale(I);

% flip function
I3 = flip(I,0);
I3_2 = flip(I, 1);
I3_3 = flip(I, 2);

% rotation function
I4 = rotation(I, pi/3);

% resize function
I5 = resize(I, 0.6);
I5_2 = resize(I, 1.5);

%% show image
figure('name', 'grey scale image'),
imshow(I2);
figure('name', 'flipped image (Horizontal)'),
imshow(I3);
figure('name', 'flipped image (Vertical)'),
imshow(I3_2);
figure('name', 'flipped image (Horizontal + Vertical)'),
imshow(I3_3);
figure('name', 'rotated image'),
imshow(I4);
figure('name', 'resized image (0.6x)'),
imshow(I5);
figure('name', 'resized image (1.5x)'),
imshow(I5_2);

%% write image
% save image for your report
filename2 = '../results/grey_image.jpg';
imwrite(I2, filename2);
filename3 = '../results/flip_image(Horizontal).jpg';
imwrite(I3, filename3);
filename3_2 = '../results/flip_image(Vertical).jpg';
imwrite(I3_2, filename3_2);
filename3_3 = '../results/flip_image(Horizontal+Vertical).jpg';
imwrite(I3_3, filename3_3);
filename4 = '../results/rotated_image.jpg';
imwrite(I4, filename4);
filename5 = '../results/resized_image(0.6x).jpg';
imwrite(I5, filename5);
filename5_2 = '../results/resized_image(1.5x).jpg';
imwrite(I5_2, filename5_2);

%% for image 2
% read image
filename = '../image2.jpg';
Is = imread(filename);
figure('name', 'source image');
imshow(Is);

%% ----- call functions ----- %%
% output = function(input1, input2, ...);
% grey_scale function
Is2 = grey_scale(Is);

% flip function
Is3 = flip(Is,0);
Is3_2 = flip(Is, 1);
Is3_3 = flip(Is, 2);

% rotation function
Is4 = rotation(Is, pi/3);

% resize function
Is5 = resize(Is, 0.6);
Is5_2 = resize(Is, 1.5);

%% show image
figure('name', 'grey scale image'),
imshow(Is2);
figure('name', 'flipped image (Horizontal)'),
imshow(Is3);
figure('name', 'flipped image (Vertical)'),
imshow(Is3_2);
figure('name', 'flipped image (Horizontal + Vertical)'),
imshow(Is3_3);
figure('name', 'rotated image'),
imshow(Is4);
figure('name', 'resized image (0.6x)'),
imshow(Is5);
figure('name', 'resized image (1.5x)'),
imshow(Is5_2);

%% write image
% save image for your report
filename2 = '../results/my_grey_image.jpg';
imwrite(Is2, filename2);
filename3 = '../results/my_flip_image(Horizontal).jpg';
imwrite(Is3, filename3);
filename3_2 = '../results/my_flip_image(Vertical).jpg';
imwrite(Is3_2, filename3_2);
filename3_3 = '../results/my_flip_image(Horizontal+Vertical).jpg';
imwrite(Is3_3, filename3_3);
filename4 = '../results/my_rotated_image.jpg';
imwrite(Is4, filename4);
filename5 = '../results/my_resized_image(0.6x).jpg';
imwrite(Is5, filename5);
filename5_2 = '../results/my_resized_image(1.5x).jpg';
imwrite(Is5_2, filename5_2);







