function [key, info] = key(seed)
%Seed-to-key funciton.
%   Coverts string/char to numeric key used to identify
%   experiment configuration.

if ~nargin, key=0; info=''; return; end
key = seed;
if isstring(seed), seed = convertStringsToChars(seed); end
if ischar(seed)
    seed = split(seed, ':');
    if length(seed) == 1
        seed = strip(seed{1});
        seed = seed(1);
        info=''; 
    else
        info = strip([seed{2:end}]); 
        seed = strip(seed{1});
    end
    key = prod(double(seed)); 
end
if ~isnumeric(key), error("[make.key] Invalid seed."); end

end