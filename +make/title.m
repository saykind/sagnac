function title = title(seed)
%Initialization function.
%   Numeric key selects pre-defined experiment setups:
%       104 'h' -  Hall effect measurement

key = make.key(seed);

switch key
    case make.key('tk')
        title = "Kerr effect (time)";
    case {11960, make.key('hs:')}
        title = "Hall sensor";
    case {84, 'T', 'Temperature'}
        title = "Temperature measurement";
    case {68, 'D', 'Diode'}
        title = "Diode Temperature measurement";
    case {104, 'h', 'hall'}
        title = "Hall effect measurement";
    case {112, 'p', 'power'}
        title = "Optical power measurement";
    case {100, 'd', 'dc'}
        title = "DC voltage, Diode current sweep";
    case 11600 % td : dc voltage (time only)
        title = "time vs dc voltage";
    case {107, 'k', 'kerr'}
        title = "Kerr Effect";
    case {121, 'y'}
        title = "Hysteresis Kerr";
    case {105, 'i'}
        title = "Laser intensity";
    case {102, 'f'}
        title = "Modulation frequency sweep";
    case {97, 'a'}
        title = "Modulation amplitude sweep";
    case {9894, 'fa'}
        title = "Modulation frequency and amplituide sweep";
    case 14520  %xy: Kerr 2D scan
        title = "Kerr 2D scan";
    case 120  %x: Kerr 1D scan
        title = "Kerr 1D scan";
    case {119, 'w', 'wavelength'}
        title = "Emission Spectrum measurement";
    case 'u'
        title = "User defined experiment";
    otherwise
        title = "title";
        fprintf("[make.title] Unkown key.\n");
end