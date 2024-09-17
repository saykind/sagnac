function [x1, y1, x2, y2, r1, r2, kerr] = lockin(lockin, options)
%LOCKIN extract first and second harmonic data from lockin data structure array.
%
% Example:
%   [x1, y1, x2, y2, r1, r2, kerr] = util.logdata.lockin(logdata.lockin, 'x1_offset', options.x1_offset);

arguments
    lockin (1,:) struct
    options.sls (1,1) double = 0.1              % Second lockin sensitivity
    options.attenuation1 (1,1) double = 1.03    % Atteplotnuation factor of first harmonic signal
    options.attenuation2 (1,1) double = 10.08   % Attenuation factor of second harmonic signal
    options.x1_offset (1,1) double = 0;         % Offset for first harmonic signal
    options.scale1  (1,1) double = 1e6          % Scale factor for first harmonic signal
    options.scale2  (1,1) double = 1e3          % Scale factor for second harmonic signal
    options.verbose (1,1) logical = false       % Display progress
end

    %Check is AUX1 is present as field name
    if isfield(lockin, 'AUX1')
        if options.verbose
            util.msg('Assuming second harmonic signal is in AUX1 and AUX2 fields.');
        end
        sls = options.sls;
        x1 = lockin.X;
        y1 = lockin.Y;
        x2 = sls*lockin.AUX1;
        y2 = sls*lockin.AUX2;
    end

    if isfield(lockin, 'x') && size(lockin.x, 2) == 6
        if options.verbose
            util.msg('Assuming data was recorded by ZI HF2LI.');
        end
        if ~isnan(lockin.x(1,4))
            attenuation1 = options.attenuation1;
            attenuation2 = options.attenuation2;
            x1 = lockin.x(:,1)*attenuation1;
            y1 = lockin.y(:,1)*attenuation1;
            x2 = lockin.x(:,4)*attenuation2;
            y2 = lockin.y(:,4)*attenuation2;
        end
        if isnan(lockin.x(1,4))
            x1 = lockin.x(:,1);
            y1 = lockin.y(:,1);
            x2 = lockin.x(:,2);
            y2 = lockin.y(:,2);
        end
    end

    % Check if x1 and y1 are present
    if ~exist('x1', 'var') || ~exist('y1', 'var')
        util.msg('Cannot find first harmonic data in provided lockin data.');
    end

    if options.x1_offset
        x1 = x1 - options.x1_offset;
    end
    if nargout > 4
        r1 = sqrt(x1.^2 + y1.^2);
    end
    if nargout > 5
        r2 = sqrt(x2.^2 + y2.^2);
    end
    if nargout > 6
        kerr = util.math.kerr(x1, r2);
    end

    if options.scale1 ~= 1
        x1 = x1*options.scale1;
        y1 = y1*options.scale1;
    end
    if options.scale2 ~= 1
        x2 = x2*options.scale2;
        y2 = y2*options.scale2;
        if nargout > 4
            r1 = r1*options.scale2;
        end
        if nargout > 5
            r2 = r2*options.scale2;
        end
    end
