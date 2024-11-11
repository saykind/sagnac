function [seed, comment] = parse(seed)
%PARSE seed string 
    if isstring(seed), seed = convertStringsToChars(seed); end
    if ischar(seed)
        seed = split(seed, ':');
        if isscalar(seed)            
            comment = "";
            seed = string(strip(seed{1}));
        else
            comment = strip(seed);
            seed = string(seed{1});
            comment = comment(2:end);
            comment = strcat(comment, "; ");
            comment = [comment{:}];
            comment = string(comment(1:end-2));
        end
    end
end