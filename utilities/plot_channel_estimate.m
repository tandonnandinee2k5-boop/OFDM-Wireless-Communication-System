function fig = plot_channel_estimate(H, Hlin, Hdft, cfg, symIdx, graphTitle)
% PLOT_CHANNEL_ESTIMATE
% Compares the true channel magnitude with the two pilot-based estimates
% for one OFDM symbol. Circles mark the pilot subcarriers.

k = 0:cfg.fftSize-1;

fig = figure;
plot(k, abs(H(symIdx,:)),    'k-',  'LineWidth', 2); hold on;
plot(k, abs(Hlin(symIdx,:)), 'm--', 'LineWidth', 1.3);
plot(k, abs(Hdft(symIdx,:)), 'g-.', 'LineWidth', 1.5);
plot(cfg.pilotIdx - 1, abs(Hlin(symIdx, cfg.pilotIdx)), 'ro', 'MarkerSize', 6);

grid on;
xlabel('Subcarrier index');
ylabel('|H(k)|');
title(graphTitle);
legend('True channel', 'LS + linear interpolation', ...
       'LS + DFT interpolation', 'Pilot subcarriers', 'Location', 'best');

end
