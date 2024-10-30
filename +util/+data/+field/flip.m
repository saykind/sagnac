function flip(options)
%Change sign of magnet current in datafile.

arguments
    options.filenames string = [];
    options.verbose (1,1) logical = true;
end

filenames = options.filenames;
if isempty(filenames)
    filenames = convertCharsToStrings(util.filename.select());
end
if isempty(filenames)
    util.msg('No file selected.');
    return;
end

for i = 1:numel(filenames)
    filename = filenames(i);
    data = load(filename);
    logdata = data.logdata;
    logdata.magnet.I = -logdata.magnet.I;
    data.logdata = logdata;
    
    filename_new = util.filename.change(filename, '', 'postfix', '-flipped');
    save(filename_new, '-struct', 'data');
    if options.verbose, fprintf("Flipped magnet current in %s\n", filename); end
end

end