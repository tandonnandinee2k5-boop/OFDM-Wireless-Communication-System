function [rxSignal, H] = rayleigh_channel(txSignal, snr, fftSize, pdp)
% RAYLEIGH_CHANNEL
% Frequency-selective Rayleigh block-fading channel plus AWGN.
%
%   txSignal : numSymbols x (fftSize + cpLength) matrix (one OFDM symbol per row)
%   snr      : Es/N0 per subcarrier in dB (same definition as awgn_channel)
%   fftSize  : number of subcarriers
%   pdp      : power delay profile (one entry per tap), normalised to sum 1
%
%   rxSignal : received signal, same size as txSignal
%   H        : numSymbols x fftSize channel frequency response (for equalisation)
%
% Every OFDM symbol sees its own independent channel, constant over the
% symbol (block fading). The cyclic prefix must be at least L-1 samples
% long, where L is the number of taps, so there is no inter-symbol interference.

if nargin < 4 || isempty(pdp)
    pdp = exp(-(0:3)/1.5);              % 4-tap exponential decay
end
pdp = pdp(:).' / sum(pdp);              % total channel power = 1

[numSym, symLen] = size(txSignal);
L        = numel(pdp);
cpLength = symLen - fftSize;

if L - 1 > cpLength
    error('Cyclic prefix (%d) must be at least L-1 = %d samples.', cpLength, L-1);
end

% Complex Gaussian tap gains: h_l ~ CN(0, pdp(l))
h = (randn(numSym, L) + 1j*randn(numSym, L)) / sqrt(2);
h = h .* repmat(sqrt(pdp), numSym, 1);

% Row-wise linear convolution, truncated to the symbol length
rxSignal = zeros(numSym, symLen);
for l = 1:L
    delayed  = [zeros(numSym, l-1), txSignal(:, 1:symLen-l+1)];
    rxSignal = rxSignal + repmat(h(:,l), 1, symLen) .* delayed;
end

% Noise power is set from the transmitted signal, so the average SNR
% is exactly the requested value
sigPower = mean(abs(txSignal(:)).^2);
noiseVar = sigPower / 10^(snr/10);
rxSignal = rxSignal + sqrt(noiseVar/2) * ...
           (randn(numSym, symLen) + 1j*randn(numSym, symLen));

% Frequency response of each symbol's channel
H = fft([h, zeros(numSym, fftSize - L)], [], 2);

end
