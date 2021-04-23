%Creation des matrices de localisation des events
format long g;  %modif du format de calcul pour augmenter la precision
tabloc = [-1;1];
channel = HDD.CH;   % verifier la bonne colonne qui correspond au channel dans la matrice choisie
tps = HDD.Time;              % v�rifier o� se trouve le temps dans la matrice choisie

 v=4600000;% vitesse de propagation des ondes en mm/s >> changer la valeur
 d=65;% distance entre les deux capteurs >> changer la valeur

iloc=1;
for ct=1:height(HDD)-1
    dif=abs(tps(ct)-tps(ct+1));    % calcul de la difference de temps entre deux salves
    if dif<(d)/v                    % peuvent elles etre localis�es?
        if channel(ct,1)==1
            local_1(iloc,1)=ct;                   % sauvegarde du numero de l'evenement
            local_1(iloc,2)=tps(ct);
            local_1(iloc,3)=HDD.CH(ct);
            local_1(iloc,4)=dif;
            local_1(iloc,5)=tabloc(HDD.CH(ct))*local_1(iloc,4)*v/2+d/2;
        else
            ct=ct+1;
            local_1(iloc,1)=ct;                   % sauvegarde du numero de l'evenement
            local_1(iloc,2)=tps(ct);
            local_1(iloc,3)=HDD.CH(ct);
            local_1(iloc,4)=-dif;
            local_1(iloc,5)=tabloc(HDD.CH(ct))*local_1(iloc,4)*v/2+d/2;   
        end
        iloc=iloc+1;
    end;
end;

%Localisation capteur 2
iloc=1;
for ct=1:height(HDD)-1
    dif=abs(tps(ct)-tps(ct+1));    % calcul de la difference de temps entre deux salves
    if dif<(d)/v                    % peuvent elles etre localis�es?
        if channel(ct,1)==2
            local_2(iloc,1)=ct;                   % sauvegarde du numero de l'evenement
            local_2(iloc,2)=tps(ct);
            local_2(iloc,3)=HDD.CH(ct);
            local_2(iloc,4)=dif;
            local_2(iloc,5)=tabloc(HDD.CH(ct))*local_1(iloc,4)*v/2+d/2; 
        else
            ct=ct+1;
            local_2(iloc,1)=ct;                   % sauvegarde du numero de l'evenement
            local_2(iloc,2)=tps(ct);
            local_2(iloc,3)=HDD.CH(ct);
            local_2(iloc,4)=-dif;
            local_2(iloc,5)=tabloc(HDD.CH(ct))*local_1(iloc,4)*v/2+d/2;  % Localisation capteur 2
        end
        iloc=iloc+1;
    end;
end;
figure();
plot(local_1(:,2),local_1(:,5),'r.');
figure();
plot(local_2(:,2),local_2(:,5),'b.');
