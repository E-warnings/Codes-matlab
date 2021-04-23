[datahit_sur_pente_cap1,datahit_sur_pente_cap2]=separer_capteur(datahit_sur_pente);     %cr?e deux matrices pour cap 1 et cap2

all_FO_cap1=[datahit_sur_pente_cap1(:,2),datahit_sur_pente_cap1(:,4)];                  %matrice de tous les hits en deux colonnes temps et force/ faire attention ? la colonne correspondant au capteur

all_FO_cap1(~any(all_FO_cap1'),:)=[ ] ;                                                 %enl?ve les lignes de 0 s'il y en avait du au filtrage des donn?es sur pente (energie/duration)

fo_ref=all_FO_cap1(1,:);                                                                %d?finie le temps et la force pour la forme d'onde de r?f?rence
    
[FO_ref]=extraire_fo_de_ref(fo_ref,datahit_sur_pente);                                  %aller chercher l'emplacement de la forme d'onde et donner le d?but du nom par exemple si le nom des FO est essai_040d_1_1.txt essai_040d_1_2.txt etc alors prendre comme racine essai_040d_


%% Cr?ation de matrices

eval(['[forme_d_onde,DH,FO_brut,FO,FO_recal,mat_FO_brut]=creation_matrice(all_FO_cap1,datahit_sur_pente_cap1, FO_ref);']); 

%eval(['[forme_d_onde,DH,FO_brut,FO_temps_essai,mat_FO_brut]=creation_matrice_start(all_FO_cap1,hdd040n2, FO_ref_cap1);']);

% cr?ation de diff?rentes matrices pour regrouper les formes d'ondes et pouvoir analyser les diff?rentes correlations
% forme_d_onde : matrice r?capitualtive des diff?rents parametres des FO : {'channel number';'WF number';'Energie (aJ)';'Dur?e (?s)';'Amplitude (dB)';'Amplitude (V)';'temps (s)';}  
% DH           : tous les param?tres acoustiques des hits du cap choisi
% FO_brut      : matrices de deux colonnes des diff?rentes salves temps et amp d'origine
% FO           : matrices de deux colonnes des diff?rentes salves temps recal? sur le max de la FO de ref et amp d'origine
% FO_recal     : matrices des FO de longueur de 3000 points avec le temps recal? sur la FO de ref
% mat_FO_brut  : matrice des amplitudes en V de toutes les FO consid?r?s dans cursor_info



%% cr?ation de la matrice diagonale de coefficients de corr?lation pour un grand nombre de FO: cr?e plusieurs fichiers

Coeff_dt=zeros(1,size(mat_FO_brut,2));
Coeff=zeros(1,size(mat_FO_brut,2));
for i=1:size(mat_FO_brut,2)
i
for j=(i):size(mat_FO_brut,2)
[Coeff(j) Coeff_dt(j)]= max(xcorr(mat_FO_brut(1:3000,i),mat_FO_brut(1:3000,j),'coeff'));
end
eval(['save ''Coeff_dt_',num2str(i),'.mat'' Coeff_dt;']);
eval(['save ''Coeff',num2str(i),'.mat'' Coeff;']);
end;

% r?cuperer les multifiles : 
Coeff_EN_vrac=zeros(size(mat_FO_brut,2),size(mat_FO_brut,2)); 
NB=size(mat_FO_brut,2);
 
for i=1:NB
NB-i,
eval(['load ''Coeff_',num2str(i),'.mat'';']);
Coeff_EN_vrac(i,:)= Coeff;
end


for i=1:NB
NB-i,
eval(['load ''Coeff_dt_',num2str(i),'.mat'';']);
dt_EN_vrac(i,:)= Coeff_dt;
end

%tracer la matrice des coeff de corr?lation en couleur
figure,imagesc(Coeff_EN_vrac);

% lecture ?crite du gros fichier
hdf5write('Coeff_EN_vrac.hdf5', '/dataset1', Coeff_EN_vrac);
% You can then read the data back into matlab using: 
hdf5read('Coeff_EN_vrac.hdf5', '/dataset1');
 
% lecture ?crite du gros fichier
hdf5write('dt_EN_vrac.hdf5', '/dataset1', dt_EN_vrac);
% You can then read the data back into matlab using: 
hdf5read('dt_EN_vrac.hdf5', '/dataset1');
 
 
%% Cr?ation de la matrice de corr?lation des salves pour un nombre de FO faible

Coeff=zeros(size(mat_FO_brut,2),size(mat_FO_brut,2));
Coeff_dt=zeros(size(mat_FO_brut,2),size(mat_FO_brut,2));
save 'Coeff.mat' Coeff;% -v7.3;
save 'Coeff_dt.mat' Coeff_dt;% -v7.3;
for i=1:size(mat_FO_brut,2)
i
for j=(i):size(mat_FO_brut,2)
[Coeff(i,j) Coeff_dt(i,j)]= max(xcorr(mat_FO_brut(:,i),mat_FO_brut(:,j),'coeff'));
end
save 'Coeff.mat' Coeff -append;
save 'Coeff_dt.mat' Coeff_dt -append;
end;

Coeff_dt_s=(Coeff_dt-10000)/5e6; %tradtuit en temps en secondes le d?calage au max de corr?lation ATTENTION 153259 et 5e6 peuvent changer! 153259points si toute la longueur 5e6 si ?chantillonage ? 5MHz
Coeff_dt_s=triu(Coeff_dt_s); %ne prend que la matrice diagonale sup?rieur, mets des 0 ailleurs

%% Cr?ation de la matrice de corr?lation / example sp?cifique

Coeff=zeros(size(mat_FO_brut_M1_start_cap1_int10,2),size(mat_FO_brut_M1_start_cap1_int10,2));
Coeff_dt=zeros(size(mat_FO_brut_M1_start_cap1_int10,2),size(mat_FO_brut_M1_start_cap1_int10,2));
save 'Coeff.mat' Coeff;% -v7.3;
save 'Coeff_dt.mat' Coeff_dt;% -v7.3;
for i=1:size(mat_FO_brut_M1_start_cap1_int10,2)
i
for j=(i):size(mat_FO_brut_M1_start_cap1_int10,2)
[Coeff(i,j) Coeff_dt(i,j)]= max(xcorr(mat_FO_brut_M1_start_cap1_int10(:,i),mat_FO_brut_M1_start_cap1_int10(:,j),'coeff'));
end
save 'Coeff.mat' Coeff -append;
save 'Coeff_dt.mat' Coeff_dt -append;
end;
Coeff_dt_s=(Coeff_dt-2000)/50e6; %tradtuit en temps en secondes le d?calage au max de corr?lation ATTENTION 153259 et 5e6 peuvent changer! 153259points si toute la longueur 5e6 si ?chantillonage ? 5MHz
Coeff_dt_s=triu(Coeff_dt_s);


%% Cr?ation de la matrice de corr?lation du cap2 en fc du Cap1 (ou inversement)

for i=1:size(mat_FO_brut_M1_start_cap1_int10,2)
[Coeff(i) Coeff_dt(i)]= max(xcorr(mat_FO_brut_M1_start_cap2_int10(:,i),mat_FO_brut_M1_start_cap1_int10(:,i),'coeff'));
end;
Coeff_dt_s=(Coeff_dt-2000)/50e6; %tradtuit en temps en secondes le d?calage au max de corr?lation ATTENTION 153259 et 5e6 peuvent changer! 153259points si toute la longueur 5e6 si ?chantillonage ? 5MHz
Coeff_dt_s=triu(Coeff_dt_s);


%% correlation d'une salve compar?e ? sa plus proche voisine en temps

Coeff_1to1=zeros(size(mat_FO_brut,2)-1,1);
Coeff_dt_1to1=zeros(size(mat_FO_brut,2)-1,1);

save 'Coeff_1to1.mat' Coeff_1to1;% -v7.3;
save 'Coeff_dt_1to1.mat' Coeff_dt_1to1;% -v7.3;
for i=1:(size(mat_FO_brut,2)-1)
i
[Coeff_1to1(i,1) Coeff_dt_1to1(i+1,1)]= max(xcorr(mat_FO_brut(1:10000,i),mat_FO_brut(1:10000,i+1),'coeff'));
save 'Coeff_1to1.mat' Coeff_1to1 -append;
save 'Coeff_dt_1to1.mat' Coeff_dt_1to1 -append;
end;

for i=1:(size(mat_FO_brut,2)-1)
i
[Corr_1to1(:,i) lag_1to1(:,i)]= xcorr(mat_FO_brut(1:10000,i),mat_FO_brut(1:10000,i+1),'coeff');
end;
[M,I] = max(abs(Corr_1to1));
lagDiff = lag_1to1(I);
timeDiff = lagDiff/5e6;
Coeffall_1to1=[M',timeDiff'];



 
%% Histogramme 

Coeff_NO1=triu(triu(Coeff)-tril(Coeff)); %enleve les 1 sur la diagonale et met ? zero la matrice inf?rieure
All_coeff=Coeff_NO1(:); %cr?e une colonne simple des coeff de corr?lation de la matrice
All_coeff=All_coeff(find(All_coeff)); %enl?ve les zeros

Coeff_dt_s=(Coeff_dt-15359)/5e6; 
Coeff_dt_s=triu(Coeff_dt_s);

[N,X]=hist(All_coeff,50); %histogramme 
createfigure_hist_wafa(X,N/size(All_coeff,1)); %trace l'histogramme des donn?es normalis?es au nombre total de corr?lations
% createfigure_coeff(All_coeff);



% save 'Coeff.mat' Coeff;% -v7.3;
% save 'Coeff_dt.mat' Coeff_dt;% -v7.3;
% for i=2314:size(mat_FO_brut,2)
% i
% for j=(i):size(mat_FO_brut,2)
% [Coeff(i,j) Coeff_dt(i,j)]= max(xcorr(mat_FO_brut(:,i),mat_FO_brut(:,j),'coeff'));
% end
% save 'Coeff.mat' Coeff -append;
% save 'Coeff_dt.mat' Coeff_dt -append;
% end; 

%% plot figure salves


good:

figure;
for i=1:length(M1_cap1);
fo=M1_cap1(i,1);
fig2=plot(FO_brut_cap1(1:2000,1,210),FO_brut_cap1(1:2000,2,210));
hold on;
plot(FO_brut_cap1(1:2000,1,fo)+M1_cap1(i,2),FO_brut_cap1(1:2000,2,fo),'Color', couleur_long(i,:), 'lineWidth', [1]);
set(fig2,'DisplayName',['FO n?' num2str(fo)])
end;

figure;
for i=1:length(M2);
fo=M2(i,1);
 fig2=plot(FO_brut(:,1,910),FO_brut(:,2,910));
hold on;       
plot(FO_brut(:,1,fo)+M2(i,2),FO_brut(:,2,fo),'Color', couleur(i,:), 'lineWidth', [1]);
    set(fig2,'DisplayName',['FO n?' num2str(fo)])  
end

figure;
for i=1:length(M3);
fo=M3(i,1);
time=DH(fo,2);
force=DH(fo,4);
fig1=plot((time-temps)/10,force/65,'+', 'color', couleur(i,:), 'Markersize', 20, 'linewidth', [2]);
hold on
set(fig1,'DisplayName',['FO n?' num2str(fo)])
end





%% graph des FO et coeff correl pris en vrac
figure,subplot(2,1,1);
for i=1:5:9146;
fig2=plot(FO_brut_cap1_start(1:300,1,4000)*10^6,FO_brut_cap1_start(1:300,2,4000));
hold on;
plot((FO_brut_cap1_start(1:300,1,i)+cap1_ref4000(i,4))*10^6,FO_brut_cap1_start(1:300,2,i),'Color', couleur_long(i,:), 'lineWidth', [1]);
set(fig2,'DisplayName',['FO n?' num2str(i)])
end;
xlabel('Time (?s)','FontSize',24,'FontName','Cambria');
ylabel('Voltage (V)','FontSize',24,'FontName','Cambria');
subplot(2,1,2);
for i=1:5:9146;
fig2=plot(cap1_ref4000(4000,5),cap1_ref4000(4000,3),'.');
hold on;
plot(cap1_ref4000(i,5),cap1_ref4000(i,3),'.','Color', couleur_long(i,:), 'MarkerSize', [6]);
end;
xlabel('Waveform N?','FontSize',24,'FontName','Cambria');
ylabel('Correlation Coefficient','FontSize',24,'FontName','Cambria');

%%exemple sp?cifique:
figure,subplot(2,1,1);
for i=2:56;
fig2=plot(FO_brut(1:2000,1,1)*10^6,FO_brut(1:2000,2,1));
hold on;
plot((FO_brut(1:2000,1,i)+Coeff_dt_s(i,1))*10^6,FO_brut(1:2000,2,i),'Color', couleur_long(i,:), 'lineWidth', [1]);
set(fig2,'DisplayName',['FO n?' num2str(i)])
end;
xlabel('Time (?s)','FontSize',24,'FontName','Cambria');
ylabel('Voltage (V)','FontSize',24,'FontName','Cambria');
subplot(2,1,2);
for i=2:56;
fig2=plot(vrac5(1,1)/10,vrac5(1,3),'.');
hold on;
plot(vrac5(i,1),vrac5(i,3),'.','Color', couleur_long(i,:), 'MarkerSize', [6]);
end;
xlabel('Number of cycles','FontSize',24,'FontName','Cambria');
ylabel('Correlation Coefficient','FontSize',24,'FontName','Cambria');

%%plot subplot
figure,subplot(2,1,1);
for i=2:56;
fig2=plot(FO_brut(1:300,1,1)*10^6,FO_brut(1:300,2,1));
hold on;
plot((FO_brut(1:300,1,i)+vrac5(i,4))*10^6,FO_brut(1:300,2,i),'Color', couleur_long(i,:), 'lineWidth', [1]);
set(fig2,'DisplayName',['FO n?' num2str(i)])
end;
xlabel('Time (?s)','FontSize',24,'FontName','Cambria');
ylabel('Voltage (V)','FontSize',24,'FontName','Cambria');
set(gca,'FontSize',20,'FontName','Cambria')
set(gca,'XLim',[-10 60])
set(gca,'YLim',[-30 30])
subplot(2,1,2);
for i=2:56;
fig2=plot(vrac5(1,5),vrac5(1,3),'.');
hold on;
plot(vrac5(i,5),vrac5(i,3),'.','Color', couleur_long(i,:), 'MarkerSize', [6]);
end;
xlabel('Waveform','FontSize',24,'FontName','Cambria');
ylabel('Correlation Coefficient','FontSize',24,'FontName','Cambria');
set(gca,'FontSize',20,'FontName','Cambria');

%sans subplot: juste les FOs:
figure,
for i=1:506;
fig2=plot(time_int(1:3000)*10^6,mat_FO_brut_M2_1_int(1:3000,1)*1000);
hold on;
plot((time_int(1:3000)+Coeff_dtM2_1_s(1,i))*10^6,mat_FO_brut_M2_1_int(1:3000,i)*1000,'Color', couleur_long(i,:), 'lineWidth', [1]);
set(fig2,'DisplayName',['FO n?' num2str(i)])
end;
xlabel('Time (?s)','FontSize',24,'FontName','Cambria');
ylabel('Voltage (mV)','FontSize',24,'FontName','Cambria');
set(gca,'FontSize',20,'FontName','Cambria')
set(gca,'XLim',[-20 30])
set(gca,'YLim',[-60 60])


%%
%PLOTYYY : figure 3 axes stress energy et cofficients de corr?lation pour mulitplets

ylabels{1}='Stress (MPa)'; ylabels{2}='Energy (aJ) '; ylabels{3}='Correlation coefficient';
[ax,hlines] = plotyyy((DH1_M1(:,2))./10,DH1_M1(:,4)./section,(DH1_M1(:,2))./10,DH1_M1(:,18),(DH1_M1(:,2))./10,CoeffM1_allLentgh(1,:),ylabels);
set(ax(1),'FontSize',20,'FontName','Cambria')
set(ax(2),'FontSize',20,'FontName','Cambria')
set(ax(3),'FontSize',20,'FontName','Cambria')
xlabel('Number of cycles','FontSize',24,'FontName','Cambria');
set(hlines(1),'Marker','.')
set(hlines(2),'Marker','*')
set(hlines(3),'Marker','.')
set(hlines(1),'LineStyle','.')
set(hlines(2),'LineStyle','.')
set(hlines(3),'LineStyle','.')


%% localisation



C=zeros(size(datahit_local1,1)*2,size(datahit_local1,2));
C(1:2:(size(C,1)-1),:)=datahit_local1;
C(2:2:size(C,1),:)=datahit_local2;

d=59;    % distance entre les capteurs en mm
v=5000000;   % vitesse de propagation des ondes en mm/s
% les donn? sont dans la matrice data
format long g;  %modif du format de calcul pour augmenter la precision
iloc=1;
tabloc=[-1;1];
channel=Coeff_1to1(:,3);   % verifier que la colonne 1 de data correspond au channel
tps=Coeff_1to1(:,4);              % le temps ds la 3ieme collonne en s
for ct=1:length(tps)-1
dif=abs(tps(ct)-tps(ct+1));    % calcul de la difference de temps entre deux salves
if dif<(d)/v                              % peuvent elles etre localis?es?
local(iloc,1)=ct;                   % sauvegarde du numero de l'evenement
local(iloc,2)=tps(ct);
local(iloc,3)=channel(ct);
local(iloc,5)=tabloc(channel(ct))*dif*v/2+d/2;
local(iloc,4)=dif;
local(iloc,7)=tabloc(channel(ct))*abs(Coeff_1to1(ct,2))*v/2+d/2;
local(iloc,6)=Coeff_1to1(ct,2);
iloc=iloc+1;
end;
end;
