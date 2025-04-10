function c = matlab(name)
%STANFORD  Return default MATLAB color based on the color name
% from https://www.mathworks.com/help/matlab/creating_plots/specify-plot-colors.html

    switch name
        case {'red', 'scarlet'}
            c = " #A2142F";  % (dark red) scarlet
        case {'orange', 'brick'}
            c = " #D95319";  % (orange) red
        case 'blue'
            c = " #0072BD";  % blue
        case 'cyan'
            c = " #4DBEEE";  % cyan
        case 'green'
            c = " #77AC30";  % green
        case 'yellow'
            c = " #EDB120";  % yellow
        case 'purple'
            c = " #7E2F8E";  % purple
        case 'white'
            c = " #FFFFFF";  % white
        case 'black'
            c = " #000000";  % black
        otherwise
            c = " #000000";  % black
    end

    c = strtrim(c);

    end