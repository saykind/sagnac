function write340(RT, options)
% Record data from RT table to Lakeshore 340 calibration file.
% It uses data format 4 (Log10 Ohms/Kelvin).
%
% Writes text file with the following header:
%   Sensor Model: <model name>	
%   Serial Number: 	<serial num>
%   Data Format: 4 (Log Ohms/Kelvin)		
%   SetPoint Limit: 350.0 (Kelvin)	
%   Temperature coefficient: 1 (Negative)		
%   Number of Breakpoints: <num points>		
%		
%   No. 	Units 	Temperature (K)
%   1	1.831223561	299
%   2	1.835069398	296
%   ...
%
% Arguments:
%    RT - Table with the following columns:
%         - No (index)
%         - Units (resistance, voltage)
%         - Temperature (K)
%    options - Struct with the following fields:
%        filename (1,:) char = 'temp.340'
%        model (1,:) char = 'David'
%        serial (1,:) char = 'Saykin'
%        dataformat (1,1) double = 4
%        setpoint (1,1) double = 350.0
%        coefficient (1,1) double = 1
%        num_points (1,1) double = height(RT)



    arguments
        RT table
        options.filename (1,:) char = 'temp.340'
        options.model (1,:) char = 'David'
        options.serial (1,:) char = 'Saykin'
        options.dataformat (1,1) double = 4
        options.setpoint (1,1) double = 350.0
        options.coefficient (1,1) double = 1
        options.num_points (1,1) double = height(RT)
    end

    filename = options.filename;
    model = options.model;
    serial = options.serial;
    dataformat = options.dataformat;
    setpoint = options.setpoint;
    coefficient = options.coefficient;
    num_points = options.num_points;

    filename = util.filename.ext(filename, '.340');

    % Open file
    fid = fopen(filename, 'w');
    if fid == -1
        error("Could not open file: %s", filename);
    end

    % Write header
    fprintf(fid, 'Sensor Model: %s\r\n', model);
    fprintf(fid, 'Serial Number: %s\r\n', serial);
    fprintf(fid, 'Data Format: %d\r\n', dataformat);
    fprintf(fid, 'SetPoint Limit: %.1f (Kelvin)\r\n', setpoint);
    fprintf(fid, 'Temperature coefficient: %d\r\n', coefficient);
    fprintf(fid, 'Number of Breakpoints: %d\r\n\r\n', num_points);

    % Write data
    fprintf(fid, 'No.\tUnits\tTemperature (K)\r\n');
    for i = 1:num_points
        fprintf(fid, '%d\t%.9f\t%.2f\r\n', RT.No(i), RT.Units(i), RT.Temperature(i));
    end

    % Close file
    fclose(fid);

end

