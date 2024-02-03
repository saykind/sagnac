function [beam_diameter] = beamspot(focal_length, waist_diameter, wavelength)
%Calculate beam spot diameter
%
%   Args:
%       - focal_length, mm
%       - waist_diameter, mm
%       - wavelength, nm
%   Out:
%       - beam_diameter, um
%
%   focal_length length and waist diameter should be in the same units
%   wavelength should be in nanometers
%   output diameter in microns
    if nargin < 3, wavelength = 1550; end
    beam_diameter = 4*wavelength/pi*focal_length/waist_diameter*1e-3;
end

