function symbols = qpsk_modulator(bits)
% QPSK_MODULATOR
% Gray-mapped QPSK with unit average symbol energy (Es = 1).
% Written in base MATLAB, so no Communications Toolbox is needed.
%   bit pair (b1 b2) -> ((1-2*b1) + j*(1-2*b2)) / sqrt(2)
%   00 -> ( 1+j)/sqrt2     01 -> ( 1-j)/sqrt2
%   10 -> (-1+j)/sqrt2     11 -> (-1-j)/sqrt2

if mod(length(bits),2) ~= 0
    error('Number of bits must be even.');
end

bitPairs = reshape(bits, 2, []).';
symbols  = ((1 - 2*bitPairs(:,1)) + 1j*(1 - 2*bitPairs(:,2))) / sqrt(2);

end
