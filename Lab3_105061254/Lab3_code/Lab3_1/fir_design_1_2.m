N = 1000;
Fs = 500;

% fir1(n, [f1 f2], 'stop')
% f1 and f2 are normalized to the Nyquist frequency
%wo = 60/(Fs/2);
%bw = 0.04; %wo/35;
%a = 1;
%b = fir1(100, [wo-bw/2 wo+bw/2], 'stop');
%high pass(2) part
%c = 1;
%d = fir1(100, 0.05, 'high');

%sys = tf(b,a);
%P = pole(sys);
%Z = zero(sys);
%figure(1)
%zplane(Z, P)
%title('100th order FIR notch filter');

% [num. den] = iirnotch(w0, bw)
%wo = 60/(Fs/2);
%bw = wo/35; %let q factor = 35
%[b, a] = iirnotch(wo, bw);
%sys = tf(b,a);
%P = pole(sys);
%Z = zero(sys);
%figure(1)
%zplane(Z, P)
%title('2nd order IIR notch filter');

% moving average filter
pt = 8;
b = ones(1,pt)/pt;
a = 1;

sys = tf(b,a);
%P = pole(sys);
%Z = zero(sys);
%figure(1)
%zplane(Z, P)
%title('moving average filter');

figure(2);
freqz(b,a,N);
%freqz(c,d,N);
%remove DC bias
%N = 1000;
%for i = 1:N
%    y_new(i) = y(i) - 308;
%end
y2 = filter(b, a, y);
%y2 = filter(d, c, y2);
cut = 1;
y2 = y2(cut:N);
%%
% ECG signal for 6.
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
%f_axis = (0:1:(N-1))*df;   % frequency axis
f_shift = (-N/2:1:N/2-1)*df;

ECG_frequency = fft(y); % spectrum of sampled cosine, freqeuncy domain, complex
ECG_frequency = fftshift(ECG_frequency); 
%ECG_frequency = fftshift(ECG_frequency);
mag_ECG_frequency = abs(ECG_frequency);   % magnitude
pha_ECG_frequency = angle(ECG_frequency); % phase

subplot(2,2,3)
plot(f_shift, mag_ECG_frequency);
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
%f_axis = (0:1:(N - cut))*df;   % frequency axis
f_shift = (-(N - cut)/2:1:(N - cut)/2)*df;
ECG_frequency = fft(y2); % spectrum of sampled cosine, freqeuncy domain, complex
ECG_frequency = fftshift(ECG_frequency); 

%ECG_frequency = fftshift(ECG_frequency);
mag_ECG_frequency = abs(ECG_frequency);   % magnitude
pha_ECG_frequency = angle(ECG_frequency); % phase

subplot(2,2,4)
plot(f_shift, mag_ECG_frequency);
xlabel('Frequency (Hz)');
title('Spectrum of whole ECG');
axis([-inf inf 0 300000]);