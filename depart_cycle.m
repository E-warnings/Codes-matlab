function [x0,maxi,mini] = depart_cycle(TDD,fc)
    %    Fonction calculant le temps de départ du cyclage
    %     (cad à la valeur minimale du premier cycle)
    %    Donne également les valeurs max et min d'un cycle 
    fe = 1/(TDD.Time(2)-TDD.Time(1)); % Frequence d'échantillonage (si tps des TDD en secondes)
    len = size(TDD.Time);
    x10 = round(len(1)/10); % Valeur ou l'on se positionne pour trouver max/min

    %   1  Détection max/min d'un cycle à partir de la contrainte à 10% du tps total de l'essai 

    [maxi,tmax] = max(TDD.PARA1(x10:(x10+round(fe/fc))));
    [mini,tmin] = min(TDD.PARA1(x10:(x10+round(fe/fc))));
    tmax = tmax+x10;
    tmin = tmin+x10;
    moy = (maxi+mini)/2;

    %   2  Détection départ cyclage
    maxi95 = maxi*0.95;
    xmax = find(TDD.PARA1>=maxi95);
    [Mini1er, x] = min(TDD.PARA1(xmax(1):(xmax+round(fe/fc))));
    x0 = x+xmax(1)-1;
end

