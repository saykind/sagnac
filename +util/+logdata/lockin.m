function [x1, y1, x2, y2] = lockin(lockin, options)
%LOCKIN extract first and second harmonic data from lockin data structure array.

arguments
    lockin (1,:) struct
    options.sls (1,1) double = 0.1          % Second lockin sensitivity
    options.attenuation (1,1) double = 10   % Attenuation factor of second harmonic signal
    options.verbose (1,1) logical = false   % Display progress
end

%Check is AUX1 is present as field name
if isfield(lockin, 'AUX1')
    if options.verbose
        disp('[util.logdata.lockin] Assuming second harmonic signal is in AUX1 and AUX2 fields.');
    end
    sls = options.sls;
    x1 = lockin.X;
    y1 = lockin.Y;
    x2 = sls*lockin.AUX1;
    y2 = sls*lockin.AUX2;
    return;
end

if isfield(lockin, 'x') && size(lockin.x, 2) == 6
    if options.verbose
        disp('[util.logdata.lockin] Assuming data was recorded by ZI HF2LI.');
    end
    attenuation = options.attenuation;
    x1 = lockin.x(:,1);
    y1 = lockin.y(:,1);
    x2 = lockin.x(:,4)*attenuation;
    y2 = lockin.y(:,4)*attenuation;
end
