function ber = calculate_ber(txBits, rxBits)
% CALCULATE_BER
% Computes the Bit Error Rate

numErrors = sum(txBits ~= rxBits);

ber = numErrors/length(txBits);

end