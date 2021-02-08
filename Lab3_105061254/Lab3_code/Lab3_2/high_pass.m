fs = 500;
% fir1(n, [f1 f2], 'stop')
% f1 and f2 are normalized to the Nyquist frequency

a = fir1(100, [0.22 0.26], 'stop');
b = fir1(100, 0.02, 'high');

%remove DC bias
N = 1000;
%for i = 1:N
%    y_new(i) = y(i) - 308;
%end
y = filter(a, 1, y);

%figure(1);
%plot(y2)

y = filter(b, 1, y)

figure(2)
plot(y)

cut = 2;
y = y(cut:N);

%%
% ECG signal for 6.
N = 1000;
Fs = 500;
t = 0 : 1/Fs : (N - 1) * 1/Fs;
%t = 0 : 1 : (N - 1);

figure(3);
subplot(2,2,1)
plot(t, y)
xlabel('time (s)');
title('whole ECG');
%%
dt = 1/Fs;  % time resolution

% Fourier transform
df = Fs/N; % frequency resolution
f_axis = (0:1:(N-1))*df;   % frequency axis
ECG_frequency = fft(y); % spectrum of sampled cosine, freqeuncy domain, complex
ECG_frequency = fftshift(ECG_frequency); 
%ECG_frequency = fftshift(ECG_frequency);
mag_ECG_frequency = abs(ECG_frequency);   % magnitude
pha_ECG_frequency = angle(ECG_frequency); % phase

subplot(2,2,3)
plot(f_axis, mag_ECG_frequency);
xlabel('Frequency (Hz)');
title('Spectrum of whole ECG');
%%
% ECG signal for 6.
t = 0 : 1/Fs : (N - cut) * 1/Fs;
%t = 0 : 1 : (N - 1);

subplot(2,2,2)
plot(t, y2)
xlabel('time (s)');
title('whole ECG');
%%
dt = 1/Fs;  % time resolution

% Fourier transform
df = Fs/N; % frequency resolution
f_axis = (0:1:(N - cut))*df;   % frequency axis
ECG_frequency = fft(y2); % spectrum of sampled cosine, freqeuncy domain, complex
ECG_frequency = fftshift(ECG_frequency); 
%ECG_frequency = fftshift(ECG_frequency);
mag_ECG_frequency = abs(ECG_frequency);   % magnitude
pha_ECG_frequency = angle(ECG_frequency); % phase

subplot(2,2,4)
plot(f_axis, mag_ECG_frequency);
xlabel('Frequency (Hz)');
title('Spectrum of whole ECG');