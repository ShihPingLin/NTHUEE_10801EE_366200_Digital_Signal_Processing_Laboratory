% ECG signal for 6.
N = 15000;
t = 0 : 1/Fs : (N - 1) * 1/Fs;
%t = 0 : 1 : (N - 1);

subplot(2,2,1)
plot(t, ECG)
xlabel('time (s)');
title('whole ECG');
%%
dt = 1/Fs;  % time resolution

% Fourier transform
df = Fs/N; % frequency resolution
f_axis = (0:1:(N-1))*df;   % frequency axis
ECG_frequency = fft(ECG); % spectrum of sampled cosine, freqeuncy domain, complex
%ECG_frequency = fftshift(ECG_frequency); 
mag_ECG_frequency = abs(ECG_frequency);   % magnitude
pha_ECG_frequency = angle(ECG_frequency); % phase

subplot(2,2,3)
plot(f_axis, mag_ECG_frequency);
xlabel('Frequency (Hz)');
title('Spectrum of whole ECG');
%%
N_2 = 1760;
ECG_2 = ECG(1:N_2);

t_2 = 0 : 1/Fs : (N_2 - 1) * 1/Fs;
%t = 0 : 1 : (N - 1);

subplot(2,2,2)
plot(t_2, ECG_2)
xlabel('time (s)');
title('single ECG');
%%
dt = 1/Fs;  % time resolution

% Fourier transform
df_2 = Fs/N_2; % frequency resolution
f_axis_2 = (0:1:(N_2-1))*df_2;   % frequency axis
ECG_frequency_2 = fft(ECG_2); % spectrum of sampled cosine, freqeuncy domain, complex
%ECG_frequency = fftshift(ECG_frequency); 
mag_ECG_frequency_2 = abs(ECG_frequency_2);   % magnitude
pha_ECG_frequency_2 = angle(ECG_frequency_2); % phase

subplot(2,2,4)
plot(f_axis_2, mag_ECG_frequency_2);
xlabel('Frequency (Hz)');
title('Spectrum of single ECG')