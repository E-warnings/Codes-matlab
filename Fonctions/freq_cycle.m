function Fc = freq_cycle(TDD)
    N = height(TDD.Time); % Nbre de valeurs discretes de la série étudiée
    Te = (TDD.Time(2)-TDD.Time(1)); % Période d'échantillonage en Hz
    t = fix(N/3); 

    %Tracé du spectre 
    figure();
    tfx = fft(TDD.PARA1(fix(N/8):(fix(N/8)+t)));
    N = t+1;
    freq = [0:N-1]/(N*Te);
%     [Affichage] facultatif
    stem(freq,abs(tfx)/N);%stem est un type de plot souvent utilisé pour représenter les spectres
    xlabel('Fréquence en Hz');
    ylabel('Composantes de Fourier (normalisées)');
    xlim([0.01 5]);

    [m,xm] = max(abs(tfx(2:end)));
    Fc = roundn(freq(xm),-1);
end

