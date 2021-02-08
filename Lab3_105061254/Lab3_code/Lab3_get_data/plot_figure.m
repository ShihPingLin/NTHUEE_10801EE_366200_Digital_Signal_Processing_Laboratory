% ECG signal for 6.
N = 1000;
Fs = 500;
t = 0 : 1/Fs : (N - 1) * 1/Fs;
%t = 0 : 1 : (N - 1);

subplot(2,1,1)
plot(t, y)
xlabel('time (s)');
title('whole ECG');
%%
dt = 1/Fs;  % time resolution

% Fourier transform
df = Fs/N; % frequency resolution
f_axis = (0:1:(N-1))*df;   % frequency axis
ECG_frequency = fft(y); % spectrum of sampled cosine, freqeuncy domain, complex
%ECG_frequency = fftshift(ECG_frequency); 
ECG_frequency = fftshift(ECG_frequency);
mag_ECG_frequency = abs(ECG_frequency);   % magnitude
pha_ECG_frequency = angle(ECG_frequency); % phase

subplot(2,1,2)
plot(f_axis, mag_ECG_frequency);
xlabel('Frequency (Hz)');
title('Spectrum of whole ECG');