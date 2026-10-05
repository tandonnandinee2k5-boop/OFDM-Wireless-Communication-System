function fig = plot_constellation(symbols, graphTitle, markerSize, axisLim)
% PLOT_CONSTELLATION
% Plots a constellation diagram and returns the figure handle.
%   markerSize : (optional) marker size, default 8
%   axisLim    : (optional) show the range [-axisLim, axisLim] on both axes,
%                useful when a few outliers (deep fades) stretch the plot

if nargin < 3 || isempty(markerSize), markerSize = 8; end

fig = figure;

scatter(real(symbols(:)), imag(symbols(:)), markerSize, 'filled');

xlabel('In-Phase (I)');
ylabel('Quadrature (Q)');
title(graphTitle);

grid on;
axis equal;

if nargin >= 4 && ~isempty(axisLim)
    xlim([-axisLim axisLim]);
    ylim([-axisLim axisLim]);
end

end
