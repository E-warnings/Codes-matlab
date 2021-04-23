
Im = imread('circuit.tif'); %load the image;
Im = double(Im)/255; %convert to double, range 0-1;
figure, imshow(Im); %show the image;
title('Image of circuit'); %add caption to the image;



[H,d] = imhist(Im); %compute histogram of the image;
figure, plot(d,H); %show the histogram function;
xlabel('d'); %add caption to the x-axis;
ylabel('H'); %add caption to the y-axis;
title('Histogram of circuit'); %add caption to the plot;



MN = sum(H); %count histogram area;
H = H./MN; %normalize histogram;
figure, plot(d,H); %show normalized histogram;
xlabel('d');
ylabel('probability');
title('Probability of circuit');




%compute mean value from the histogram;
mu = sum(H.*d) / sum(H)




figure, plot(d,H);
xlabel('d');
ylabel('probability');
title('Probability of circuit and mean value');
%add mean value to the probaility plot;
hold on, plot([mu,mu],[0,max(H)],'r');




%compute mean value from the image;
mu = mean( reshape( Im,size(Im,1)*size(Im,2),1 ) )




%compute median from the image;
Me = median( reshape( Im,size(Im,1)*size(Im,2),1 ) )
%compute mode from the image;
Mo = mode( reshape( Im,size(Im,1)*size(Im,2),1 ) )
figure, plot(d,H);
xlabel('d');
ylabel('probability');
title('Probability of circuit with median and mode values');
%add median value to the probaility plot;
hold on, plot([Me,Me],[0,max(H)],'-.*r');
%add mode value to the probaility plot;
hold on, plot([Mo,Mo],[0,max(H)],':*g');





%compute variance from the normalized histogram;
sigma2 = sum(H.*(d-mu).^2)
%compute standard deviation;
sigma = sqrt(sigma2)




%compute variance from the image;
sigma2 = var( reshape( Im,size(Im,1)*size(Im,2),1 ) )
%compute standard deviation;
sigma = std( reshape( Im,size(Im,1)*size(Im,2),1 ) )




%compute inter quartile range;
Q = iqr( reshape( Im,size(Im,1)*size(Im,2),1 ) )



%compute entropy of the image;
S = entropy(Im)




%find where normalized histogram equals zero;
f =find(H==0);
%exclude zero values from computation;
Hx = H;
Hx(f) = [];
%compute entropy from the normalized histogram without zero values;
S = -sum(Hx.*log2(Hx))



%show histogram and entropy of circuit image;
figure, imshow(Im);
title(['Circuit, entropy S = ',num2str(S)]);
figure, imhist(Im);
title(['Histogram of circuit, entropy S = ',num2str(S)]);



%show histogram and entropy of gaussian noise;
J = imnoise(zeros(size(Im)),'Gaussian',.5,.1);
SJ = entropy(J)
figure, imshow(J);
title(['Gaussian noise, entropy S = ',num2str(SJ)]);
figure, imhist(J);
title(['Histogram of Gaussian noise, entropy S = ',num2str(SJ)]);



%show histogram and entropy of cell image;
C = imread('cell.tif');
C = double(C)/255;
SC = entropy(C)
figure, imshow(C);
title(['Cells, entropy S = ',num2str(SC)]);
figure, imhist(C);
title(['Histogram of cells, entropy S = ',num2str(SC)]);



%show histogram and entropy of unique value;
U = ones(size(Im))*.5;
SU = entropy(U)
figure, imshow(U);
title(['Unique intensity value, entropy S = ',num2str(SU)]);
figure, imhist(U);
title(['Histogram of unique intensity value, entropy S = ',num2str(SU)]);



%compute entropy filtering with small structure element;
F = entropyfilt(Im);
figure, imshow(F,[]);
title('Entropy filtering of circuit, se = true(9)');



%compute entropy filtering with middle structure element;
F = entropyfilt(Im,true(41));
figure, imshow(F,[]);
title('Entropy filtering of circuit, se = true(41)');



%compute entropy filtering with large structure element;
F = entropyfilt(Im,true(91));
figure, imshow(F,[]);
title('Entropy filtering of circuit, se = true(91)');



HA = zeros(size(H)); %empty lower histogram;
HB = zeros(size(H)); %empty upper histogram;
%empty cumulative distribution function;
C = zeros(size(H));
%cumulative distribution function;
C(1) = H(1);
for k = 2:length(H),
    C(k) = C(k-1) + H(k);
end;
C = double(C);
%cycle through intensity levels;
for k = 1:length(H),
    if C(k) > 0, %only for positive cumulation;
        for w = 1:k, %from beginning till now;
            if H(w) > 0, %only for positive histogram
                %compute the lower histogram value
                HA(k) = HA(k) - ( H(w)/C(k)) * log2(H(w)/C(k) );

            end; %endif;
        end; %endfor;
    end; %endif;
    if ( 1-C(k) ) > 0, %only for positive cumulation residuals;
        for w = k + 1:length(H); %from now till end;
            if H(w) > 0, %only for positive histogram
                %compute the lower histogram value
                HB(k) = HB(k) - ( H(w)/(1-C(k))) * log2(H(w)/(1-C(k)) );
            end; %endif;
        end; %endfor
    end; %endif
end; %endfor
%locate the maxima for joined histograms
[co, kde] = max(HA+HB);
%selet threshold
Th = d( kde-1 )
%segment image
II = im2bw(Im, Th);
figure, imshow(II);
title(['Entropy segmentation of circuit, Th = ', num2str(Th)]);



%cycle through the histogram;
for T=2:length(H)-1,
    w(1) = sum( H(1:T) ); %probability of first class
    u(1) = sum( H(1:T) .* d(1:T) ); %class mean
    %protection against zero;
    if w(1) == 0,
        u(1) = 0;
    else
        %class mean recomputation;
        u(1) = u(1)/w(1);
    end;
    w(2) = sum( H( (T+1):end) ); %probability of second class
    u(2) = sum( H( (T+1):end) .* d( (T+1):end) ); %class mean
    %protection against zero;
    if w(2) == 0,
        u(2) = 0;
    else
        %class mean recomputation;
        u(2) = u(2)/w(2);
    end;
    %between class variance;
    ut = w*u';
    sigmaB(T) = w(1)*(u(1)-ut)^2 + w(2)*(u(2)-ut)^2;
end;
%find maximal between class variance
[e,r] = max(sigmaB);
TTh(1) = d(r); %set Treshold




TTh = graythresh(Im); %compute threshold;
IO = im2bw(Im, TTh); %segment image;
figure, imshow(IO);
title(['Otsu segmentation of circuit, Th = ', num2str(TTh)]);




%load images(s)
C = imread('cell.tif');
%C = imread('cameraman.tif');
%C = imread('circuit.tif');
C = double(C)/255;
S = entropy(C); %compute entropy
%compute average probability of one pixel
pomo = 1/numel(C);
[H,d] = imhist(C); %compute histogram
H = H./sum(H); %normalize histogram
IE = zeros(size(C)); %empty result image;
%cycle through intensity levels;
for k=1:length(H);
    %precompute second histograms;
    G = H;
    %remove pixel contribution;
    if G(k)>=pomo,
        G(k) = G(k) - pomo;
    end;
    %protection against zero;
    f =find(G==0);
    G(f) = [];
    G = G./sum(G); %renormalization;
    %entropy without pixel;
    E(k) = -sum(G.*log2(G));
    %point information gain;
    PIG(k) = S-E(k);
    %assign pig to pixels;
    f = find(C==k/255);
    IE(f) = PIG(k);
end;
figure, imshow(IE,[]);
title('Point Information Gain of the cells.');
%title('Point Information Gain of the cameraman.');
%title('Point Information Gain of the circuit.');



%load images(s)
C = imread('cameraman.tif');
%C = imread('circuit.tif');
C = double(C)/255;
S = entropy(C); %compute entropy
%compute average probability of one pixel
pomo = 1/numel(C);
[H,d] = imhist(C); %compute histogram
H = H./sum(H); %normalize histogram
IE = zeros(size(C)); %empty result image;
%cycle through intensity levels;
for k=1:length(H);
    %precompute second histograms;
    G = H;
    %remove pixel contribution;
    if G(k)>=pomo,
        G(k) = G(k) - pomo;
    end;
    %protection against zero;
    f =find(G==0);
    G(f) = [];
    G = G./sum(G); %renormalization;
    %entropy without pixel;
    E(k) = -sum(G.*log2(G));
    %point information gain;
    PIG(k) = S-E(k);
    %assign pig to pixels;
    f = find(C==k/255);
    IE(f) = PIG(k);
end;
figure, imshow(IE,[]);
title('Point Information Gain of the cameraman.');
%title('Point Information Gain of the circuit.');




%load images(s)
C = imread('circuit.tif');
C = double(C)/255;
S = entropy(C); %compute entropy
%compute average probability of one pixel
pomo = 1/numel(C);
[H,d] = imhist(C); %compute histogram
H = H./sum(H); %normalize histogram
IE = zeros(size(C)); %empty result image;
%cycle through intensity levels;
for k=1:length(H);
    %precompute second histograms;
    G = H;
    %remove pixel contribution;
    if G(k)>=pomo,
        G(k) = G(k) - pomo;
    end;
    %protection against zero;
    f =find(G==0);
    G(f) = [];
    G = G./sum(G); %renormalization;
    %entropy without pixel;
    E(k) = -sum(G.*log2(G));
    %point information gain;
    PIG(k) = S-E(k);
    %assign pig to pixels;
    f = find(C==k/255);
    IE(f) = PIG(k);
end;
figure, imshow(IE,[]);
title('Point Information Gain of the circuit.');

