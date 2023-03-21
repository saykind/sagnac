function init(obj, seed)
%Initialization function.
%   seed char creates pre-defined experiment setups:
%       'r' -   transport (single SR830 lockin)
%       't' -   transport (two SR830 lockins)
%       'T' -   temperature (LSCI331)
%       'k' -   Kerr (SR844)
%       'K' -   Kerr & transport
%       'A' -   all available instruments

if nargin < 1, seed = '0'; end
switch seed
    case {'T', 'temp'}
        obj.title = "Temperature vs time";
        obj.readme = ['LSCI331 is connected to DT-670 ', ...
                'temperature sensors.\n', ...
                'tempA ia sample, tempB is magnet.'];
    case {'h', 'hall'}
        obj.title = "Hall effect measurement";
        obj.readme = ['LSCI331 controls temperature', ...
                'SR830_12 records Vxx.\n', ...
                'SR830_30 supplies current', ...
                'through 10 Mohms, records Vxy.\n,', ...
                'KEPCO supplies magnet current.'];
    case {'A', 'all'} % record all available instruments
        obj.title = "All available instruments";
        obj.readme = ['All instruements ', ...
            'that are connected through GPIB are recorded'];
    case 'u'
        obj.title = "User defined experiment";
        obj.readme = 'User has to provide readme manually.';
    otherwise
        fprintf("[Recorder] Unkown experiment configuration.");
        obj.title = "Unspecified measurement";
        obj.readme = "Unspecified measurement.";
end

obj.foldername = "data";
obj.schema = Recorder.make_schema(seed);