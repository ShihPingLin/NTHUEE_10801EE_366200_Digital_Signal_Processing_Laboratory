clc;
clear;
load('no_notch_1000_point.mat');

% real time processing (try)
% y is the test data
N = 1000;
Fs = 500;

% cut DC bias
y2 = y - 300;

% 60-Hz moving average filter (8-pt)
pt = 8;
f1 = ones(1, pt) / pt;
y2 = conv(y2, f1, 'same');


% difference filter(slope calculation)
f2 = [1 -1];
y3 = conv(y2, f2, 'same');

% squaring
y4 = y3 .* y3;

% low pass filter
pt2 = 23;
f3 = ones(1, pt2) / pt2;
y5 = conv(y4, f3, 'same');

% threshold
[~,locs_Rwave] = findpeaks(y5,'MinPeakHeight', 1500, 'MinPeakDistance',100);

t = 0 : 1 : N-1;
plot(t,y2);
hold on
plot(locs_Rwave,y2(locs_Rwave),'ro','MarkerFaceColor','r');
hold off
