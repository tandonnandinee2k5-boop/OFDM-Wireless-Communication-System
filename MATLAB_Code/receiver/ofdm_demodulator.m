function receivedSymbols = ofdm_demodulator(rxOFDM)
% OFDM_DEMODULATOR
% Converts time-domain OFDM symbols back to frequency-domain symbols

receivedSymbols = fft(rxOFDM, [], 2);

end