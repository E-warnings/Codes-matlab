function [outputArg1,outputArg2] = cycles_TDD(TDD,fc)
    [x0, maxi, mini] = depart_cycle(TDD,fc);
    fe = 1/(TDD.Time(2)-TDD.Time(1)); % Frequence d'échantillonage (si tps des TDD en secondes)
    len = size(TDD.Time);
    cycle = 1;
    f = fix(fe/fc);
    [m, xm] = min(TDD.PARA1((x0+f/2):(x0+5*f/4)));
    xmini = x0+xm+f/2-1;
    distX = xmini-x0+1;
    x = x0-1;

    while x <= len(1)
       for i = (x+1):xmini
           TDD.CYCLES(i) = cycle+(1-(xmini-i)/distX);
       end
       x = xmini;
       [m, xm] = min(TDD.PARA1((x+8*f/10):(x+11*f/10)));   
       xmini = x+xm+8*f/10-1;
       cycle = cycle+1;
       distX = xmini-x+1;
    end 
end

