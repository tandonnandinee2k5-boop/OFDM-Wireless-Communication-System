function cfg = pilot_config(fftSize, spacing)
% PILOT_CONFIG
% Comb-type pilot layout: one known pilot every "spacing" subcarriers,
% in every OFDM symbol. The remaining subcarriers carry data.
%
%   cfg.pilotIdx     pilot subcarrier indices (1-based)
%   cfg.dataIdx      data subcarrier indices (1-based)
%   cfg.pilotSymbols known pilot values (unit energy)
%   cfg.numPilots, cfg.numData, cfg.spacing, cfg.fftSize
%
% fftSize must be a multiple of spacing, so that the pilot grid is regular
% and repeats with period fftSize (needed for the DFT-based estimator).

if mod(fftSize, spacing) ~= 0
    error('fftSize must be a multiple of the pilot spacing.');
end

cfg.fftSize      = fftSize;
cfg.spacing      = spacing;
cfg.pilotIdx     = 1:spacing:fftSize;
cfg.numPilots    = numel(cfg.pilotIdx);
cfg.dataIdx      = setdiff(1:fftSize, cfg.pilotIdx);
cfg.numData      = numel(cfg.dataIdx);
cfg.pilotSymbols = ((1 + 1j)/sqrt(2)) * (-1).^(0:cfg.numPilots-1);

end
