function rxSignal = awgn_channel(txSignal, snr)
% AWGN_CHANNEL
% Adds complex white Gaussian noise so that the SNR (dB) of the whole
% signal matrix equals snr. Equivalent to awgn(x, snr, 'measured'), but
% written in base MATLAB.
%
% With unit-energy QPSK symbols and MATLAB's ifft/fft scaling, this SNR
% equals Es/N0 on every subcarrier (see docs/theory.md).

sigPower = mean(abs(txSignal(:)).^2);
noiseVar = sigPower / 10^(snr/10);
noise    = sqrt(noiseVar/2) * (randn(size(txSignal)) + 1j*randn(size(txSignal)));
rxSignal = txSignal + noise;

end
