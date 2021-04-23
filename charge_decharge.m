%prog charge decharge
offset=72.38;   %entrer la valeur à retirer pour se mettre au début du cyclage en se basant sur les TDD
f=1;        %entrer la valeur de la fréquence d'essai
TDD{:,16}=TDD{:,3}./8; %colonne de la contrainte dans les TDD
HDD{:,22}=HDD{:,2}-offset; %régler les HDD au début du cycle
HDD{:,23}=HDD{:,22}.*f; %colonne des cycles
HDD{:,24}=ceil(HDD{:,23}); %numéro du cycle
HDD{:,25}=HDD{:,24}-HDD{:,23};
HDD{:,26}=HDD{:,3}./8; %colonne de la contrainte dans les HDD
dc=find(HDD{:,25}>=0.25 & HDD{:,25}<=0.75); %isoler la décharge
c=find(HDD{:,25}>=0.25 & HDD{:,25}>=0.75); %isoler la charge
charge=HDD{c,:};%matrice de charge
decharge=HDD{dc,:}; %matrice décharge
TDD{:,17}=TDD{:,2}-offset;
%tdd hdd charge decharge
figure()
plot(TDD{:,2},TDD{:,16});
hold on;
plot(charge(:,2),charge(:,26),'.');
hold on;
plot(decharge(:,2),decharge(:,26),'.');
legend('tdd','charge','decharge');

%cumul hits charge
j=size(charge,1);
Signaux_cumules_charge=zeros(j, 1);
for i=1:1:j
Signaux_cumules_charge(i,1)=i;
end
clear i j ;

%cumul hits decharge
j=size(decharge,1);
Signaux_cumules_decharge=zeros(j, 1);
for i=1:1:j
Signaux_cumules_decharge(i,1)=i;
end
clear i j ;

%plot cumul hits
figure()
plot(charge(:,22),Signaux_cumules_charge,'.');
hold on;
plot(decharge(:,22),Signaux_cumules_decharge,'.');
legend('charge','decharge');

%plot cumul energy
figure()
plot(charge(:,22),cumsum(charge(:,19)),'.');
hold on;
plot(decharge(:,22),cumsum(decharge(:,19)),'.');
legend('charge','decharge');