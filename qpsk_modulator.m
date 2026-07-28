function symbols = qpsk_modulator(bits)
% QPSK_MODULATOR
% Converts binary bits to QPSK symbols

% Check if number of bits is even
if mod(length(bits),2) ~= 0
    error('Number of bits must be even.');
end

% Convert bits into groups of 2
bitPairs = reshape(bits, 2, []).';

% Convert each pair into decimal values:
% 00 -> 0
% 01 -> 1
% 10 -> 2
% 11 -> 3
data = bi2de(bitPairs, 'left-msb');

% Perform QPSK modulation (Gray coding)
symbols = pskmod(data, 4, pi/4, 'gray');

end