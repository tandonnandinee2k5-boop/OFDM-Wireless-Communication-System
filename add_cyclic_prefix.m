function txSignal = add_cyclic_prefix(ofdmSignal, cpLength)
% ADD_CYCLIC_PREFIX
% Adds a cyclic prefix to each OFDM symbol

[numRows, numCols] = size(ofdmSignal);

% Extract the last cpLength samples
cyclicPrefix = ofdmSignal(:, end-cpLength+1:end);

% Attach CP at the beginning
txSignal = [cyclicPrefix ofdmSignal];

end