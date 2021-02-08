% My Harris detector
% The code calculates
% the Harris Feature/Interest Points (FP or IP) 
% 
% When u execute the code, the test image file opened
% and u have to select by the mouse the region where u
% want to find the Harris points, 
% then the code will print out and display the feature
% points in the selected region.
% You can select the number of FPs by changing the variables 
% max_N & min_N


%%%
%corner : significant change in all direction for a sliding window
%%%

clc;
clear;
%%
% parameters
% corner response related
sigma=2;
n_x_sigma = 6;
alpha = 0.04;
% maximum suppression related
Thrshold=1;  % should be between 0 and 1000
r=6;          % k for calculate Rv


%%
% filter kernels
%dx = [-1 0 1; -1 0 1; -1 0 1]; %Prewitt % horizontal gradient filter 
dx = [-1 0 1; -2 0 2; -1 0 1];  % Sobel
dy = dx'; % vertical gradient filter
%g = fspecial('gaussian',max(1,fix(2*n_x_sigma*sigma)), sigma); % Gaussien Filter: filter size 2*n_x_sigma*sigma
g = ones(24,24) / (24*24);
%% load 'Im.jpg'
frame = imread('data/Im3.jpg');
I = double(frame);
figure(1);
imagesc(frame);
[xmax, ymax,ch] = size(I);
xmin = 1;
ymin = 1;

%%%%%%%%%%%%%%Intrest Points %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Grey scale
I_grey = double(grey_scale(I));

%%%%%%
% get image gradient  
Ix = my_imfilter(I_grey, dx);   %should respond to horizontal gradients 
Iy = my_imfilter(I_grey, dy);   %should respond to vertical gradients
% calculate Ix
% calcualte Iy
%%%%%

% get all components of second moment matrix M = [[Ix2 Ixy];[Iyx Iy2]]; note Ix2 Ixy Iy2 are all Gaussian smoothed
Ix2 = my_imfilter(Ix.^2, g);
Iy2 = my_imfilter(Iy.^2, g);
Ixy = my_imfilter(Ix.*Iy, g);
% calculate Ix2  
% calculate Iy2
% calculate Ixy
%%%%%

%% visualize Ixy
figure(2);
imagesc(Ixy);
%%%%%%% Demo Check Point -------------------


%%%%%
% get corner response function R = det(M)-alpha*trace(M)^2 
[height, width, channel] = size(I);
R = zeros(height,width);
for i = 1:height
    for j = 1:width
        M = [Ix2(i,j,1) Ixy(i,j,1);Ixy(i,j,1) Iy2(i,j,1)]; 
        R(i,j) = det(M)-alpha*(trace(M))^2;
    end
end
% calculate R
%%%%%


%% make max R value to be 1000
R=(1000/max(max(R)))*R; % be aware of if max(R) is 0 or not

%%%%%
%% using B = ordfilt2(A,order,domain) to complment a maxfilter
sze = 2*r+1; % domain width 
% [Your Code here] 
% calculate MX
%%%%%
MX = ordfilt2(R,sze^2,ones(sze));
%%%%%
% find local maximum.
RBinary = (R==MX)&(R>Thrshold); 
% calculate RBinary
%%%%%


%% get location of corner points not along image's edges
offe = r-1;
count=sum(sum(RBinary(offe:size(RBinary,1)-offe,offe:size(RBinary,2)-offe))); % How many interest points, avoid the image's edge   
R=R*0;
R(offe:size(RBinary,1)-offe,offe:size(RBinary,2)-offe)=RBinary(offe:size(RBinary,1)-offe,offe:size(RBinary,2)-offe);
[r1,c1] = find(R);

%% Display
figure(3)
imagesc(uint8(I));
hold on;
plot(c1,r1,'or');
hold off;
return;
