len = size(TDD.Time); % Nbre de valeurs discretes de la série étudiée
L = (TDD.Time(len(1))-TDD.Time(1)); % Time total du signal en µs
Fs = -1/((TDD.Time(1)-TDD.Time(2))); % Freq d'échantillonage en Hz
moy = mean(TDD.PARA1);
Y = fft((TDD.PARA1)); % Calcul FFT
P1 = Y(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
P1 = 20*log10(P1);
f = Fs*(0:(L/2))/L;
figure();
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
[m,t] = max(P1(3:end));
Fmax = f(t);

X = highpass(TDD.PARA1(10000:end),0.1);

% Y = bandpass(Y,[0.01 10],Fs);
len = size(TDD.Time); % Nbre de valeurs discretes de la série étudiée
L = (TDD.Time(len(1))-TDD.Time(1)); % Time total du signal en µs
Fs = -1/((TDD.Time(1)-TDD.Time(2))); % Freq d'échantillonage en Hz
moy = mean(TDD.PARA1);
Y1 = fft(X); % Calcul FFT
P1 = Y1(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
P1 = 20*log10(P1);
f = Fs*(0:(L/2))/L;
hold on;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t) lowpassed')
xlabel('f (Hz)')
ylabel('|P1(f)|')
[m,t] = max(P1(3:end));
Fmax = f(t);
figure();
a = 1077064;
plot(TDD.PARA1(a:(a+200)));
Y1 = fft(TDD.PARA1(a:(a+200))); % Calcul FFT
% P1 = 20*log10(P1);
f = Fs*(1:size(P1))/L;
figure();
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t) lowpassed')
xlabel('f (Hz)')
ylabel('|P1(f)|')