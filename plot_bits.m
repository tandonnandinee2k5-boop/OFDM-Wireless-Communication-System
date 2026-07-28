function plot_bits(bits)
% PLOT_BITS
% Plots the generated random bits

figure;

stem(bits,'filled');

xlabel('Bit Number');
ylabel('Bit Value');
title('Random Binary Data');

grid on;

end