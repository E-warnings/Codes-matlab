function Distrib = Distribution(n,Cor)
    stck = find(Cor <= 1/n);
    Distrib(1) = length(stck);
    for i = 2:n
        stck = find(Cor <= i*1/n);
        Distrib(i) = length(stck)-sum(Distrib);
    end
    Distrib(1) = 0;
    Distrib = Distrib/max(Distrib);
end

