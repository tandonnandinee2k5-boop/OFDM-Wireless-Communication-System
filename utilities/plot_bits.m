function plot_bits(bits)
% PLOT_BITS
% Plots the first 64 generated random bits (plotting all of them is unreadable)

figure;

stem(bits(1:64),'filled');

xlabel('Bit Number');
ylabel('Bit Value');
title('Random Binary Data (first 64 bits)');

grid on;

end
