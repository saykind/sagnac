function record(angle, power)
%RECORD a signle datapoint into the datafile.
%   Make new datafile if it does not exist.
%   Append the data to the end of the file.
%   
%   angle: angle between fast axis of QWP and polarizer axis in degrees
%   power: optical power in microWatts 

    if exist('polarimetry.mat', 'file') == 2
        data = load('polarimetry.mat');
        angle = [data.angle; angle];
        power = [data.power; power];
    end

    save('polarimetry.mat', 'angle', 'power');

end