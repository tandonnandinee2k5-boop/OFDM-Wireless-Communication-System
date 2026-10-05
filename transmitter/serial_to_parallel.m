function parallelSymbols = serial_to_parallel(symbols, N)
% SERIAL_TO_PARALLEL
% Converts serial QPSK symbols into OFDM blocks

numSymbols = length(symbols);

% Check if divisible by N
if mod(numSymbols, N) ~= 0
    error('Number of symbols must be divisible by N.');
end

% Reshape into OFDM symbols
parallelSymbols = reshape(symbols, N, []).';

end