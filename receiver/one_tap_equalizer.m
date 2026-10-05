function equalized = one_tap_equalizer(receivedSymbols, H)
% ONE_TAP_EQUALIZER
% Zero-forcing equalisation, one complex division per subcarrier:
%   Y(k) = H(k) X(k) + N(k)   ->   X_hat(k) = Y(k) / H(k)
% H must have the same size as receivedSymbols. Perfect channel knowledge
% is assumed (no channel estimation).

equalized = receivedSymbols ./ H;

end
