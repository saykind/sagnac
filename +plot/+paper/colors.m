function c = colors(ids)
% Return plot color hex string based on id.
% Positive ids are more red, negative ids are more blue.
% Increasing id by 10 switches to a different color palette.

    % Define color palettes
    red = [0.9, 0.1, 0.1];
    blue = [0.1, 0.1, 0.9];
    green = [0.1, 0.9, 0.1];
    yellow = [0.9, 0.9, 0.1];
    cyan = [0.1, 0.9, 0.9];
    magenta = [0.9, 0.1, 0.9];
    orange = [0.9, 0.5, 0.1];
    purple = [0.5, 0.1, 0.9];
    brown = [0.5, 0.3, 0.1];
    pink = [0.9, 0.5, 0.5];
    gray = [0.5, 0.5, 0.5];
    colors = {red, blue, green, yellow, cyan, magenta, orange, purple, brown, pink, gray};
    c = colors{ids};

end
