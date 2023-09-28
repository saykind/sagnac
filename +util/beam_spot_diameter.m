function [beamdiameter] = beam_spot_diameter(focal, waistdiameter, lambda)
%Calculate beam spot diameter
%
%   Args:
%       - focal, mm
%       - waistdiameter, mm
%       - lambda, nm
%   Out:
%       - beamdiameter, um
%
%   focal length and waist diameter should be in the same units
%   wavelength should be in nanometers
%   output diameter in microns
    if nargin < 3, lambda = 1550; end
    beamdiameter = 4*lambda/pi*focal/waistdiameter*1e-3;
end

