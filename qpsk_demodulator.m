function receivedBits = qpsk_demodulator(symbols)
% QPSK_DEMODULATOR
% Converts QPSK symbols back into bits

% Demodulate using Gray coding
data = pskdemod(symbols,4,pi/4,'gray');

% Convert decimal values back to bit pairs
receivedBits = de2bi(data,2,'left-msb');

% Convert matrix into column vector
receivedBits = reshape(receivedBits.',[],1);

end