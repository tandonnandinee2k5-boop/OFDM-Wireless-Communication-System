function save_figure(figName, filePath)
% SAVE_FIGURE
% Saves the figure whose Name is figName as an image.
%
% The figure is looked up by name at save time instead of using a stored
% handle, because in MATLAB's docked Figures window a stored handle can
% become invalid after the first export.

f = findall(groot, 'Type', 'figure', 'Name', figName);

if isempty(f)
    warning('Figure "%s" not found, not saved.', figName);
    return;
end

f = f(1);
drawnow;

try
    exportgraphics(f, filePath, 'Resolution', 150);
catch
    try
        saveas(f, filePath);
    catch err
        warning('Could not save %s: %s', filePath, err.message);
        return;
    end
end

fprintf('Saved %s\n', filePath);

end
