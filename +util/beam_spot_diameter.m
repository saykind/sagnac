function [beamdiameter] = beam_spot_diameter(focal, diameter, lambda)
%Calculate beam spot radius
%   focal length and waist diameter should be in the same units
%   wavelength should be in nanometers
%   output diameter in microns
    if nargin < 3, lambda = 1550; end
    beamdiameter = 4*lambda/pi*focal/diameter*1e-3;
end

