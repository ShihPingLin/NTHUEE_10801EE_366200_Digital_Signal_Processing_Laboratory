% 60Hz FIR notch filter
f_s = 500;
f_c = 60; 

omega_c = 2 * pi * f_c;     
omega_c_d = omega_c / f_s;

b_0 = [1, -2*cos(omega_c_d), 1];
a = 1;
[H, W] = freqz(b_0, a, 2048);
mag = abs(H);
W = W * f_s / (2 * pi);
subplot(2,1,1)
plot(W, 20*log(mag))
title('Frequency response(Magnitude in dB) for 60Hz FIR notch filter)');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
%%
a_0 = [1 -1.8*cos(omega_c_d), 0.81];

[H2, W2] = freqz(b_0, a_0, 2048);
mag2 = abs(H2);
W2 = W2 * f_s / (2 * pi);
subplot(2,1,2)
plot(W2, 20*log(mag2))
title('Frequency response(Magnitude in dB) for 60Hz FIR notch filter');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');