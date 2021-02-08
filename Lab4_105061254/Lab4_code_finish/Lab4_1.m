clc;
clear;
load('107m.mat');

% real time processing (try)
% y is the test data
N = 650000;
y = zeros(1, N);
y(1, 1:N) = val(1, 1:N);
Fs = 360;

% cut DC bias
%y2 = y - 300;

% 60-Hz moving average filter (8-pt)
pt = 8;
f1 = ones(1, pt) / pt;
y2 = conv(y, f1, 'same');

% dealing with group delay
%t = 0 : 1 : N-1;
%delay = -2;
%[y2, t] = Seqshift(y2, t, delay)

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
[~,locs_Rwave] = findpeaks(y5,'MinPeakHeight', 700, 'MinPeakDistance',30);

delay = 0;
t = 0 : 1 : N-1;
locs_Rwave = locs_Rwave + delay;
plot(t,y2);
hold on
plot(locs_Rwave,y2(locs_Rwave),'ro','MarkerFaceColor','r');
hold off
%%
locs_Rwave_final = round(locs_Rwave / Fs, 2);

%read the data
xlsFile = '100.xlsx';
[Data, headerText] = xlsread(xlsFile);

truth = Data';
truth2 = truth;
result = 0;
TP = 0;
for i = 2:length(truth)
    truth2(i) = truth2(i) + truth2(i - 1);
end   
truth2 = round(truth2, 2);

for i = 1:length(locs_Rwave_final)
    if truth2(1, i) == locs_Rwave_final(1, i)
        TP = TP + 1;
    end
end
TP
FN = length(truth2) - TP
FP = length(locs_Rwave_final) - TP
TN = N - TP - FN - FP
