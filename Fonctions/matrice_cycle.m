function [Cycle] = matrice_cycle(TDD,fc)
    [x0, maxi, mini] = depart_cycle(TDD,fc);
    fe = 1/(TDD.Time(2)-TDD.Time(1)); % Frequence d'échantillonage (si tps des TDD en secondes)
    len = size(TDD.Time);
    f = fix(fe/fc);
    Cycle = 0*[fix(len(1)/f),2];
    x = x0;
    i = 1;
    Cycle(i,1) = 1;
    Cycle(i,2) = TDD.Time(x); 

    while (x+11*f/10) <= len(1) 
       [m, xm] = min(TDD.PARA1((x+8*f/10):(x+11*f/10)));   
       x = x+xm+8*f/10-1;
       i = i+1;
       Cycle(i,1) = Cycle(i-1)+1;
       Cycle(i,2) = TDD.Time(x); 
    end
end

