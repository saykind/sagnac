function title = title(key)
%Initialization function.
%   Numeric key selects pre-defined experiment setups:
%       104 'h' -  Hall effect measurement

switch key
    case {84, 'T', 'Temperature'}
        title = "Temperature measurement";
    case {104, 'h', 'hall'}
        title = "Hall effect measurement";
    case {112, 'p', 'power'}
        title = "Optical power measurement";
    case {100, 'd', 'dc'}
        title = "DC voltage";
    case {119, 'w', 'wavelength'}
        title = "Emission Spectrum measurement";
    case 'u'
        title = "User defined experiment";
    otherwise
        title = "title";
        fprintf("[make.title] Unkown key.");
end