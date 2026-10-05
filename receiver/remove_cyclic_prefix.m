function rxOFDM = remove_cyclic_prefix(rxSignal, cpLength)
% REMOVE_CYCLIC_PREFIX
% Removes the cyclic prefix from each OFDM symbol

rxOFDM = rxSignal(:, cpLength+1:end);

end