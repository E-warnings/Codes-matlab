function [Mulcor1,Mulcor2,Muldt1,Muldt2] = decorrelation(Multi1,Multi2,WF,trig,impul)
    Mulcor1 = Multi1;
    Mulcor2 = Multi2;
    Muldt1 = Multi1;
    Muldt2 = Multi2;
    for i = 1:length(Multi1)
       for t = 1:length(Multi1{i}) 
            for j = (t):length(Multi1{i})
                [corr, delay] = xcorr(WF.(strcat('1_',string(Multi1{i}(t))))(trig:impul),WF.(strcat('1_',string(Multi1{i}(j))))(trig:impul),'normalized');
                [Mulcor1{i}(t,j), x] = max(corr);
                Muldt1{i}(t,j) = delay(x);
            end
       end
    end             
    for i = 1:length(Multi2)
       for t = 1:length(Multi2{i}) 
            for j = (t):length(Multi2{i})
                [corr, delay] = xcorr(WF.(strcat('2_',string(Multi2{i}(t))))(trig:impul),WF.(strcat('2_',string(Multi2{i}(j))))(trig:impul),'normalized');
                [Mulcor2{i}(t,j), x] = max(corr);                  
                Muldt2{i}(t,j) = delay(x);
            end
       end
    end
end

