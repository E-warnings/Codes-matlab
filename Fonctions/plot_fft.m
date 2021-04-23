function varargout = plot_fft(x, fs, padding, win)
%PLOT_FFT	displays Fast Fourier Transform of signal
%
%   PLOT_FFT(X, FS, PADDING, WIN) plots linear and db FFT of signal for
%   positives frequencies, using 2^(padding+nextpow2(N)) samples to
%   compute FFT (N = length(x)), with specified window applied.
%   PLOT_FFT(X, FS, PADDING) No windowing applied by default.
%   PLOT_FFT(X, FS) No PADDING by default..
%   PLOT_FFT(X) FS is 1 by default.
%
%   XFFT = PLOT_FFT(...) returns the signal FFT for positive frequencies.
%   [XFFT F] = PLOT_FFT(...) also returns the corresponding frequencies.

% Author : Winjerome
% Profil : www.developpez.net/forums/u329028/winjerome/
%
% Version : 1.0 - 24-Sept-2014


N = length(x);
if N ~= numel(x)
   error('First Input must be a vector');
end
if nargin<2
    fs = 1;
end
if nargin < 3
    padding = 0;
end
if nargin < 4
    w = 1;
else
    w = win(N);
end
nfft = 2^(padding+nextpow2(N));

X = fft(x(:).*w(:),nfft) / N;
X = 2 * X(1:floor(nfft/2));
f = fs/2 * linspace(0,1,length(X));

x_name = inputname(1);
if isempty(x_name)
    x_name = 'signal';
    figTitle = 'FFT';
else
    figTitle = ['FFF of ' x_name];
end
fig = figure('Name',figTitle,'Numbertitle','off');

axs(1) = subplot(2,1,1,'Parent',fig);
plot(axs(1), f/fs, abs(X))
xlim(axs(1), [0 0.5])
xlabel(axs(1), 'f / f_N')
ylabel(axs(1), ['|FFT( ' x_name ' )|'])
title(axs(1), 'Fast Fourier Transform (linear)')

axs(2) = subplot(2,1,2, 'Parent',fig);
plot(axs(2), f, 20*log10((abs(X))))
xlim(axs(2), [0 fs/2])
xlabel(axs(2), 'f')
ylabel(axs(2), ['20 log_1_0|FFT( ' x_name ' )|'])
title(axs(2),'Fast Fourier Transform (in dB)')

set(datacursormode(fig),'UpdateFcn',{@Cursor_fft,fs,axs})

if nargout > 0
    varargout{1} = X;
end
if nargout > 1
    varargout{2} = f;
end

function output_txt = Cursor_fft(~, event_obj, fs, axs)  
pos = get(event_obj,'Position');
switch get(event_obj.Target,'Parent')
    case axs(1)
        output_txt = {['Normalized frequency: ',addunit(pos(1),'')],...
            ['Frequency: ',addunit(fs*pos(1),'Hz')],...
            ['Amplitude: ',addunit(pos(2),'')]};
    case axs(2)
        output_txt = {['Normalized frequency: ',addunit(pos(1)/fs,'')],...
            ['Frequency: ',addunit(pos(1),'Hz')],...
            ['Amplitude : ',addunit(pos(2),'dB')]};
end

function out = addunit(value, unit)

precision = 2;

symb = {' y',' z',' a',' f',' p',' n',' µ',' m',...
        ' ', ' k',' M',' G',' T',' P',' E',' Z',' Y'};
mult = -24:3:24;

if value ~=0
    s = floor(log10(abs(value)));
else 
    s = 1;
end

if abs(s-mod(s,3))>24
     error('No SI Prefix name existing beyond 10^-/+24')
end

idx = find(mult==s-mod(s,3));
val = num2str(value/10^mult(idx),sprintf('%%3.%df',precision));
out = [val symb{idx} unit];
