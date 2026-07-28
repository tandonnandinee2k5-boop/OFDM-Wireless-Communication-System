function plot_constellation(symbols, graphTitle)
% PLOT_CONSTELLATION
% Plots the QPSK constellation

figure;

scatter(real(symbols), imag(symbols), 'filled');

xlabel('In-Phase (I)');
ylabel('Quadrature (Q)');
title(graphTitle);

grid on;
axis equal;

end