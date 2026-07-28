function serialSymbols = parallel_to_serial(receivedSymbols)
% PARALLEL_TO_SERIAL
% Converts OFDM symbols from matrix form to a column vector

serialSymbols = reshape(receivedSymbols.', [], 1);

end