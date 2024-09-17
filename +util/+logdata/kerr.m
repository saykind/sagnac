function kerr = kerr(lockin, options)
%LOCKIN extract kerr angle data from lockin data structure array.
%
% Example:
%   kerr = util.logdata.lockin(logdata.lockin, 'x1_offset', options.x1_offset);

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

options = namedargs2cell(options);
[~, ~, ~, ~, ~, ~, kerr] = util.logdata.lockin(lockin, options{:});

end