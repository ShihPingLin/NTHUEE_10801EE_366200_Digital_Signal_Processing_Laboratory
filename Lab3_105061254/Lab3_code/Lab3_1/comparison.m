N = 1000;
Fs = 500;

% fir1(n, [f1 f2], 'stop')
% f1 and f2 are normalized to the Nyquist frequency
wo = 60/(Fs/2);
bw = 0.04; %wo/35;
a1 = 1;
b1 = fir1(100, [wo-bw/2 wo+bw/2], 'stop');

sys = tf(b1,a1);
P2 = pole(sys);
%Z2 = zero(sys);
figure(1)
subplot(2,2,1)
zplane(Z2, P2)
title('100th order FIR notch filter');

% [num. den] = iirnotch(w0, bw)
wo = 60/(Fs/2);
bw = wo/35; %let q factor = 35
[b2, a2] = iirnotch(wo, bw);
sys = tf(b2,a2);
P = pole(sys);
Z = zero(sys);
subplot(2,2,2)
zplane(Z, P)
title('2nd order IIR notch filter');

% moving average filter
pt = 9;
b3 = ones(1,pt)/pt;
a3 = 1;

sys = tf(b3,a3);
P = pole(sys);
Z = zero(sys);
subplot(2,2,3)
zplane(Z, P)
title('moving average filter');

figure(2);
[h1, w1] = freqz(b1,a1,N);
[h2, w2] = freqz(b2,a2,N);
[h3, w3] = freqz(b3,a3,N);
plot(w1/pi, 20*log10(abs(h1)), w2/pi, 20*log10(abs(h2)), w3/pi, 20*log10(abs(h3)))
xlabel('Normalized Frequency(\times\pi rad/sample)')
ylabel('Magnitude(dB)')
legend('FIR', 'IIR', 'Moving Average')
title('Magnitude response comparison')
%remove DC bias
%N = 5000;
%for i = 1:N
%    y_new(i) = y(i) - 308;
%end
%y2 = filter(b, a, y);
%cut = 10;
%y2 = y2(cut:N);