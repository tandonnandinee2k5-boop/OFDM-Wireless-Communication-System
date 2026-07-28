function ofdmSignal = ofdm_modulator(parallelSymbols)
% OFDM_MODULATOR
% Converts frequency-domain symbols into time-domain OFDM symbols

ofdmSignal = ifft(parallelSymbols, [], 2);

end