clear all;
fclose('all');

serialobj=instrfind;
if ~isempty(serialobj)
    delete(serialobj)
end
clc;clear all;close all;
%s1 = serial('???');  %define serial port %Maybe 'COM14'
s1 = serial('COM5'); 
%s1.BaudRate=???;     %define baud rate   %Maybe 115200
s1.BaudRate=115200; 
 
disbuff=nan(1,1000);

fopen(s1);
clear data;
%N_point = ???;  %if 241 points
N_point = 2000;
%fs=???;   %sample rate  %Maybe 500Hz, 200Hz, 100Hz, 80Hz  %if 80Hz
fs = 500;
%time=[??:??:??];    %then 0:1/fs:3
time = 0:1/fs:1/fs*999;
figure
h_plot=plot(nan,nan);
hold off 
tic

N = 1000;
y = zeros(1,N_point);   %initalize y(new added)
y2 = zeros(1, N);
times = 0;
for i= 1:N_point 
    data=fscanf(s1);%read sensor
    y(i) = str2double(data);

    if i<=1000
    disbuff(i)=y(i);
    
    else
    disbuff=[disbuff(2:end) y(i)];
    end
       
    % 60-Hz moving average filter (8-pt)
    pt = 8; 
    if i >= pt
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
    t = t - delay;
    plot(t, y7, 'ro')
    xlabel('time (s)');
    title('whole ECG');
    axis([0 inf 0.1 inf]);
    hold off

    if i>1
    set(h_plot,'xdata',time,'ydata',disbuff)    %update the data
    title('test');
    xlabel('Time');
    ylabel('Quantization value');
    axis([0 1000*1/fs 0 1024]);
    drawnow;
    end
   
end
toc
% close the serial port
fclose(s1); 

%%
%Shih Ping Lin added 2019/9/15
% Generate sampled consine
%fc = 5; % in MHz %the source wave frequency
%fs = 100; % in MHz %the sampling frequency
%Ncycle = 20; % number of cycles of sampled cosine
%dt = 1/fs;  % time resolution
%t_axis = (0:dt:Ncycle/fc);  % time axis
%sampled_cos = cos(2*pi*fc*t_axis);  % sampled cosine ,time domain
%Npoint = length(sampled_cos);   % number of points in sampled cosine

%from early part we get the signal y(i)
% Fourier transform
df = fs/N_point; % frequency resolution
f_axis = (0:1:(N_point-1))*df;   % frequency axis

%SAMPLED_COS = fft(sampled_cos); % spectrum of sampled cosine, freqeuncy domain, complex
%mag_SAMPLED_COS = abs(SAMPLED_COS);   % magnitude
%pha_SAMPLED_COS = angle(SAMPLED_COS); % phase
Y = fft(y);
mag_Y = abs(Y);
pha_Y = abs(Y);

figure
subplot(2,1,1)
time2 = [0:1/fs:1/fs*(N_point - 1)]
%plot(t_axis, sampled_cos);
plot(time2, y);
hold
%stem(t_axis, sampled_cos,'r');
stem(time2, y, 'r');
%xlabel('Time (\mus)');
xlabel('Time')
%title('Sampled cosine (time domain)');
title('time domain signal');

subplot(2,1,2)
%plot(f_axis, mag_SAMPLED_COS);
plot(f_axis, mag_Y);
%xlabel('Frequency (MHz)');
xlabel('Frequency (Hz)');
%title('Spectrum of 5 MHz cosine (frequency domain)')
title('frequency domain spectrum')
%set(gca,'Xtick',[0 5 10 20 30 40 50 60 70 80 90 95 100]);
print -djpeg fft_example.jpg