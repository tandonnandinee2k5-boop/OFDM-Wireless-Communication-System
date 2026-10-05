function verify_signal_sizes(ofdmSignal, rxOFDM)
% VERIFY_SIGNAL_SIZES
% Compares transmitted and received OFDM signal sizes

disp('Original OFDM Signal Size:')
disp(size(ofdmSignal))

disp('Received OFDM Signal Size:')
disp(size(rxOFDM))

if isequal(size(ofdmSignal), size(rxOFDM))

    disp('✓ Signal Sizes Match')

else

    disp('✗ Signal Sizes Do Not Match')

end

end