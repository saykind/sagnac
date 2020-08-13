classdef (Sealed = true) AMI420 < handle
    %Driver for American Magnetics, 420
    %   Release August 1, 2020 (v0.1)
    %
    %   This class was created in Kapitulnik research group.
    %   Written by David Saykin (saykind@itp.ac.ru)
    %
    %   Matlab 2018b or higher is required.
    %   The following packages are used:
    %   - Instrument Control Toolbox
    %
    %
    %   Usage example:
    %   magnet = Drivers.AMI420();
    %   magnet.set('rate', 10);
    %   magnet.run();
    %   magnet.read();
    
    properties
        name = 'AMI420';
    end

end

