clc;
clear;
load('no_notch_1000_point.mat');

% real time processing (try)
% y is the test data
N = 1000;
Fs = 500;

% 60-Hz moving average filter (8-pt)
pt = 8;
N_new = 0;
y2 = zeros(1, N);
buffer = zeros(1,pt);

for i = 1:(pt-1)
    buffer(i) = y(i); 
    y2(i) = sum(buffer) / pt;
end

for i = pt:N
    for j = 1:(pt-1)
        y2(i) = y2(i) + y(i - j);
    end
    y2(i) = y2(i) / pt;
end

% difference filter(slope calculation)
y3 = zeros(1, N);
y3(1) = y2(1);
y3(2) = y2(2);
y3(3) = y2(3);
y3(4) = y2(4);
y3(5) = y2(5);
for i = 6:N
    y3(i) = y2(i) - y2(i - 1) + y2(i - 2) - y2(i - 3) + y2(i - 4) - y2(i - 5);
end

% squaring
y4 = zeros(1, N);
for i = 1:N
    y4(i) = y3(i) * y3(i);
end

% flattering(moving average LPF) (-pt)
pt = 15;
N_new = 0;
y5 = zeros(1, N);
buffer = zeros(1,pt);

for i = 1:(pt-1)
    buffer(i) = y4(i); 
    y5(i) = sum(buffer) / pt;
end

for i = pt:N
    for j = 1:(pt-1)
        y5(i) = y5(i) + y4(i - j);
    end
    y5(i) = y5(i) / pt;
end

% threshold
thd = 10000;
y6 = zeros(1, N);
for i = 1:N
    if y5(i) > thd
        y6(i) = y5(i);
    else
        y6(i) = 0;
    end
end

% local maximum
label = 1;
delay = 9;          %total group delay
y7 = zeros(1, N);    %final result
for i =2:N
    if label == 1 && (y6(i)-y6(i-1)<0)
        y7(i - 1) = y2(i - 1 - delay);
        label = 0;
    elseif label == 0 && (y6(i)-y6(i-1)==0)
        label = 1;
    end
end

t = 0 : 1 : N-1;

plot(t, y2)
xlim = ([0 1000]);
hold on
t = t - 9;
plot(t, y7, 'ro')
xlabel('time (s)');
title('whole ECG');
axis([0 inf 0.1 inf]);
hold off

%% plot time domain
% ECG signal for 6.
%t = 0 : 1/fs : (N-1)*1/fs;
t = 0 : 1 : N-1;

figure(1);
subplot(6,1,1)
plot(t, y)
xlabel('time (s)');
title('whole ECG');

subplot(6,1,2)
plot(t, y2)
xlabel('time (s)');
title('whole ECG');

subplot(6,1,3)
plot(t, y3)
xlabel('time (s)');
title('whole ECG');

subplot(6,1,4)
plot(t, y4)
xlabel('time (s)');
title('whole ECG');

subplot(6,1,5)
plot(t, y5)
xlabel('time (s)');
title('whole ECG');

subplot(6,1,6)
plot(t, y6)
xlabel('time (s)');
title('whole ECG');

figure(2);
subplot(2,1,1)
plot(t, y7, 'ro')
xlabel('time (s)');
title('whole ECG');

subplot(2,1,2)
plot(t, y)
hold on
plot(t, y7, 'ro')
xlabel('time (s)');
title('whole ECG');
hold off
%% plot frequency domain
dt = 1/Fs;  % time resolution

% Fourier transform
df = Fs/N; % frequency resolution
%f_axis = (0:1:(N-1))*df;   % frequency axis
f_shift = (-N/2:1:N/2-1)*df;

ECG_frequency = fft(y); % spectrum of sampled cosine, freqeuncy domain, complex
ECG_frequency = fftshift(ECG_frequency); 
mag_ECG_frequency = abs(ECG_frequency);   % magnitude

figure(3);
subplot(5,1,1)
plot(f_shift, mag_ECG_frequency);
xlabel('Frequency (Hz)');
title('Spectrum of whole ECG');

ECG_frequency_2 = fft(y2); % spectrum of sampled cosine, freqeuncy domain, complex
ECG_frequency_2 = fftshift(ECG_frequency_2); 
mag_ECG_frequency_2 = abs(ECG_frequency_2);   % magnitude

subplot(5,1,2)
plot(f_shift, mag_ECG_frequency_2);
xlabel('Frequency (Hz)');
title('Spectrum of whole ECG');
axis([-inf inf 0 300000]);

ECG_frequency_3 = fft(y3); % spectrum of sampled cosine, freqeuncy domain, complex
ECG_frequency_3 = fftshift(ECG_frequency_3); 
mag_ECG_frequency_3 = abs(ECG_frequency_3);   % magnitude

subplot(5,1,3)
plot(f_shift, mag_ECG_frequency_3);
xlabel('Frequency (Hz)');
title('Spectrum of whole ECG');
axis([-inf inf 0 300000]);

ECG_frequency_4 = fft(y4); % spectrum of sampled cosine, freqeuncy domain, complex
ECG_frequency_4 = fftshift(ECG_frequency_4); 
mag_ECG_frequency_4 = abs(ECG_frequency_4);   % magnitude

subplot(5,1,4)
plot(f_shift, mag_ECG_frequency_4);
xlabel('Frequency (Hz)');
title('Spectrum of whole ECG');
axis([-inf inf 0 300000]);

ECG_frequency_5 = fft(y5); % spectrum of sampled cosine, freqeuncy domain, complex
ECG_frequency_5 = fftshift(ECG_frequency_5); 
mag_ECG_frequency_5 = abs(ECG_frequency_5);   % magnitude

subplot(5,1,5)
plot(f_shift, mag_ECG_frequency_5);
xlabel('Frequency (Hz)');
title('Spectrum of whole ECG');
axis([-inf inf 0 300000]);