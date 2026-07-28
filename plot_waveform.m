function plot_waveform(signal, graphTitle)
% PLOT_WAVEFORM
% Plots the real-valued waveform

figure;

plot(signal);

xlabel('Sample Number');
ylabel('Amplitude');
title(graphTitle);

grid on;

end