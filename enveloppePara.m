function [Max1,Min1,Max2,Min2] = enveloppePara(TDD,freqcycle,Fechanti)
len = size(TDD);
tps = len(1)/Fechanti;
% On néglige le temps mort du départ et on suppose qu'il n'y a pas de pause
Nbrecycle = freqcycle*tps;
Max1 = zeros(int16(Nbrecycle),1);
Min1 = zeros(int16(Nbrecycle),1);
Max2 = zeros(int16(Nbrecycle),1);
Min2 = zeros(int16(Nbrecycle),1);

% Nombre de lignes de TABLE sur un cycle
Lignescycle = Fechanti/freqcycle;
position = 1;

for i = 1:Nbrecycle
    Max1(i) = max(table2array(TDD(position:(position+Lignescycle-1),3)));
    Min1(i) = min(table2array(TDD(position:(position+Lignescycle-1),3)));
    Max2(i) = max(table2array(TDD(position:(position+Lignescycle-1),4)));
    Min2(i) = min(table2array(TDD(position:(position+Lignescycle-1),4)));
    position = position+Lignescycle;
end


