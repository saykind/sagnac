function c = xkcd(name)
%XKCD  Return default XKCD color based on the color name
% from https://xkcd.com/color/rgb/
% reads xkcd.txt file and extracts the color in HEX format

    % Read xkcd.txt file
    fid = fopen("+plot/+color/xkcd.txt");
    xkcd = textscan(fid, '%s %s', 'Delimiter', '\t');
    fclose(fid);
    
    % Find the color
    idx = find(strcmp(xkcd{1}, name));
    if isempty(idx)
        util.msg("Color not found. Returning black.");
        c = " #000000";  % black
    else
        c = xkcd{2}{idx};
    end

    c = strtrim(c);

end