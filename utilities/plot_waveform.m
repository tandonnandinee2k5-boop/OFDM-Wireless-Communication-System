function fig = plot_waveform(signal, graphTitle)
% PLOT_WAVEFORM
% Plots a real-valued waveform and returns the figure handle

fig = figure;

plot(signal);

xlabel('Sample Number');
ylabel('Amplitude');
title(graphTitle);

grid on;

end
