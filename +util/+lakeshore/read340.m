function RT = read340(filename)
% Read data from a Lakeshore 340 calibration file.
% Returns a table with the following columns:
%   - No (index)
%   - Units (resistance, voltage)
%   - Temperature (K)
%
% Assumes that file has the following structure:
%   Sensor Model: CX-1050		
%   Serial Number: mfp		
%   Data Format: 4 (Log Ohms/Kelvin)		
%   SetPoint Limit: 330.0 (Kelvin)		
%   Temperature coefficient: 1 (Negative)		
%   Number of Breakpoints: 184		
%		
%   No. 	Units 	Temperature (K)
%   1	1.831223561	299
%   2	1.835069398	296
%   ...


    % if no filename is provided, open file browser
    if nargin == 0
        filenames = util.filename.select('*.340');
        filename = filenames{1};
    end

    % Read the file
    fid = fopen(filename);
    if fid == -1
        error("Could not open file: %s", filename);
    end

    % Skip lines until the data
    while ~feof(fid)
        line = fgetl(fid);
        if contains(line, 'No.')
            break;
        end
    end

    % Read the data
    data = textscan(fid, '%d %f %f');
    fclose(fid);

    % Create table
    RT = table(data{1}, data{2}, data{3}, 'VariableNames', {'No', 'Units', 'Temperature'});

end

