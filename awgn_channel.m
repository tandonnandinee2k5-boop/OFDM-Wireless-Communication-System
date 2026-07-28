function rxSignal = awgn_channel(txSignal, snr)
% AWGN_CHANNEL
% Adds white Gaussian noise to the transmitted signal

rxSignal = awgn(txSignal, snr, 'measured');

end