function crop(options)
%CROP 2D XY scan data and save it as a new file.

arguments
    options.filenames string = [];
    options.new_filenames string = [];
    options.xlim double {mustBeNumeric} = [];
    options.ylim double {mustBeNumeric} = [];
end