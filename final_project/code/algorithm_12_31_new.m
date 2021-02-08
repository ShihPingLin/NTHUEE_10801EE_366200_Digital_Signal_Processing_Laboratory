clc;
clear;

fs = 50;

% read data
[x, y, z] = textread('walk1_29.txt', '%d%d%d');

abs_a = abs(x) + abs(y) + abs(z);
%abs_a = abs(x-x(1)) + abs(y-y(1)) + abs(z-z(1));
abs_a_50hz = downsample(abs_a, 2);
%abs_a_50hz = abs_a;

% Arduino part
w_len = 15;
w = triang(w_len);
buffer = zeros(w_len, 1);   % buffer for filter

peak_buf = 7;
buffer2 = zeros(peak_buf, 1);   % buffer for peak
difference = zeros(peak_buf-1, 1);
peak = 0;
peak_yes = 0;
peak_pos = 0;
valley = 0;
valley_yes = 0;
valley_pos = 0;

time_window = [0.2 2];
time_window = time_window .* fs;
judge = 0;

num = 1;
step = 0;
threshold = 10000;  % from experiment : max - min > threshold then a step

min = 10000000; % for local maximum
max = 0;    % for local minimum

debug = 0;  % for debug
debug2 = [];    % for debug
debug3 = [];    % for debug
debug4 = [];    % for debug
value_test = zeros(length(abs_a_50hz), 1);   % only for testing
for i = 1:length(abs_a_50hz)  
    value = 0;
    
    % 1. update buffer value for filter
    %buffer(num, 1) = abs_a(i, 1);
    %num = num + 1;
    %if num == 16
    %    num = 1;
    %end
    for j = 1:w_len-1
        buffer(j, 1) = buffer(j+1, 1);
    end
    buffer(w_len, 1) = abs_a_50hz(i, 1);
    
    % 2. trangular filter
    for j = 1:w_len
        value = value + buffer(j, 1) * w(j);
    end
    
    % 3. find local maximum and minimum
    if value > max
        max = value;
    end
    if value < min
        min = value;
    end
    
    % 4. update buffer value for find peak
    % using value after triangular filter
    for j = 1:peak_buf-1
        buffer2(j, 1) = buffer2(j+1, 1);
    end
    buffer2(peak_buf, 1) = value;
    
    % 5. difference filter for find peak
    for j = 1:peak_buf-1
        difference(j, 1) = buffer2(j+1, 1) - buffer2(j, 1);
    end
    
    % 6. find peak
    if difference(1, 1) >= 0 && difference(2, 1) >= 0 && difference(3, 1) >= 0 && ...
            difference(4, 1) < 0 && difference(5, 1) < 0 && difference(6, 1) < 0
        peak = buffer2(4, 1);
        peak_yes = 1;
        debug = debug + 1;
        peak_pos = i-3;
    elseif difference(1, 1) < 0 && difference(2, 1) < 0 && difference(3, 1) < 0 && ...
            difference(4, 1) >= 0 && difference(5, 1) >= 0 && difference(6, 1) >= 0
        valley = buffer2(4, 1);
        valley_yes = 1;
        valley_pos = i-3;
    end
    
    % 7. setting threshold
    %threshold = (max - min) / 5;    % hyperparameter%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if peak_yes == 1 && valley_yes == 1 && (max - min) > threshold
        peak_yes = 0;
        valley_yes = 0;
        
        min = 10000000;
        max = 0;
        step = step + 1;
        debug2 = [debug2 i-3];
        debug3 = [debug3 value_test(i-3, 1)];
        debug4 = [debug4 (peak - valley)];
        % 6. setting time window
        % the time gap
        % 本次判斷時間 - 上次判斷時間是否有在時間窗口內
        %if abs((peak_pos - valley_pos)*2) > time_window(1,1) && ... 
        %        abs((peak_pos - valley_pos)*2) < time_window(1,2)
        %    step = step + 1;
        %    judge = i;
        %    debug2 = [debug2 i-3];
        %    debug3 = [debug3 value_test(i-3, 1)];
        %    peak_pos
        %    valley_pos
        %end
    end
    
    value_test(i, 1) = value;
    % we get the value : tri (rawdata after filtering)
end

step

%%
% for testing
N_point = length(value_test);
fs = 100;
time2 = 0:1/fs:1/fs*(N_point - 1);
df = fs/N_point; % frequency resolution
f_axis = (-N_point/2:1:N_point/2-1)*df;

Y = fft(value_test);
Y = fftshift(Y);
mag_Y = abs(Y);

figure(1)
%subplot(2,1,1)
%plot(time2, value_test);
plot(value_test);
%axis([-inf inf -2*10^5 2*10^5])
hold
%stem(time2, value_test, 'r');
%stem(value_test, 'r');
stem(debug2, debug3, 'r');
xlabel('Time')
title('time domain signal');
figure(2)
%subplot(2,1,2)
plot(f_axis, mag_Y);
xlabel('Frequency (Hz)');
title('frequency domain spectrum for 500Hz after trangular filter')
set(gca,'Xtick',[0 5 10 20 30 40 45 50 55 60 70 80 90 95 100]);