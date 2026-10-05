function receivedBits = qpsk_demodulator(symbols)
% QPSK_DEMODULATOR
% Hard-decision demodulator matching qpsk_modulator (Gray mapping).
% The sign of the real part gives bit 1, the sign of the imaginary part bit 2.

b1 = real(symbols) < 0;
b2 = imag(symbols) < 0;

receivedBits = reshape(double([b1(:) b2(:)]).', [], 1);

end
