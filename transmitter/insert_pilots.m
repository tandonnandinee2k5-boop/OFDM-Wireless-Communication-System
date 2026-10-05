function X = insert_pilots(dataSymbols, cfg)
% INSERT_PILOTS
% Builds the frequency-domain OFDM symbols: data on the data subcarriers,
% known pilot symbols on the pilot subcarriers.
%   dataSymbols : numSymbols x cfg.numData
%   X           : numSymbols x cfg.fftSize

numSym = size(dataSymbols, 1);

X = zeros(numSym, cfg.fftSize);
X(:, cfg.dataIdx)  = dataSymbols;
X(:, cfg.pilotIdx) = repmat(cfg.pilotSymbols, numSym, 1);

end
