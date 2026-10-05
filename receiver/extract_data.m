function dataSymbols = extract_data(X, cfg)
% EXTRACT_DATA
% Keeps only the data subcarriers (drops the pilots).

dataSymbols = X(:, cfg.dataIdx);

end
