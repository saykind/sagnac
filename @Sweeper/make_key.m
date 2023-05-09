function key = make_key(seed)
%Seed-to-key funciton. 

if ~nargin, key=0; return; end
key = seed;
if isstring(seed), seed = convertStringsToChars(seed); end
seed = seed(1);
if ischar(seed), key = double(seed); end
if ~isnumeric(key), error("[Recorder.make_key] Invalid seed."); end

end