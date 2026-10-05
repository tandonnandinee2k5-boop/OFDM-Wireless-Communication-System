function save_figure(fig, filePath)
% SAVE_FIGURE
% Saves a figure as an image. Call it right after creating the figure.
% Falls back to saveas if exportgraphics is not available or fails.

try
    if exist('exportgraphics') > 0 %#ok<EXIST>
        exportgraphics(fig, filePath, 'Resolution', 150);
    else
        saveas(fig, filePath);
    end
catch
    try
        saveas(fig, filePath);
    catch err
        warning('Could not save %s: %s', filePath, err.message);
    end
end

end
