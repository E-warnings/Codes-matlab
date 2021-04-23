function [outputArg1,outputArg2] = cycle(TDD)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    len = size(TDD.Time); % Nbre de valeurs discretes de la série étudiée
    L = (TDD.Time(len(1))-TDD.Time(1)); % Time total du signal en µs
    Fs = -1/((TDD.Time(1)-TDD.Time(2))); % Freq d'échantillonage en Hz
    Y = fft(TDD.PARA1); % Calcul FFT
    P1 = Y(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    P1 = 20*log10(P1);
    f = Fs*(0:(L/2))/L;
    figure();
    plot(f,P1) 
    title('Single-Sided Amplitude Spectrum of X(t)')
    xlabel('f (MHz)')
    ylabel('|P1(f)|')
    [t] = max(P1);
end

