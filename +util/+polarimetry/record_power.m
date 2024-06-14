function new_angle = record_power(power)
%RECORD a signle datapoint into the datafile.
%   Make new datafile if it does not exist.
%   Append the data to the end of the file.
%   Angle is assumed to be zero if there is no datafile,
%   or 10 degrees more then the last angle in the datafile.
%   
%   power: optical power in microWatts 

    if exist('polarimetry.mat', 'file') == 2
        data = load('polarimetry.mat');
        new_angle = 10 + data.angle(end);
        angle = [data.angle; new_angle];
        power = [data.power; power];
    else
        angle = 0;
        new_angle = 0;
    end

    save('polarimetry.mat', 'angle', 'power');

end