function schema = schema(seed)
%Create and save table with instrument information
%   seed:
%        84 T -- LSCI331[23].
%       114 r -- SR830[12], LSCI331[23].
%       116 t -- SR830[12], SR830[30], LSCI331[23].
%       112 p -- Optical power
%       100 d -- DC voltage
%       119 w -- wavelength sweep on Optical power detector

if nargin < 1, fprintf("[make.schema] Please provide a seed/key."); return; end
key = make.key(seed);

switch key
    case 84     %T: Single temperature controller
        name =      "tempcont";
        driver =    "LSCI331";
        interface = "visa";
        address =   23;
        parameters = {{nan}};
        fields =    {{}};
        
    case 107    %k: Kerr (main)
        name =      ["diode";   "waveform"; "voltmeter";        "lockin";   "tempcont";   "magnet"];
        driver =    ["ILX3724"; "A33220A";  "Keithley2182A";    "SR844";    "LSCI331";    "KEPCO"];
        interface = ["gpib";    "gpib";     "gpib";             "gpib";     "gpib";       "visa"];
        address =   [15;        19;         17;                 9;          23;           5];
        parameters = ...
                    {{}; ...
                     {}; ...
                     {nan}; ...
                     {}; ...
                     {nan}; ...
                     {}};
        fields =    {{'current', 'voltage', 'temperature'}; ...
                     {nan}; ...
                     {'v1'}; ...
                     {'X', 'Y', 'R', 'Q', 'AUX1', 'AUX2'}; ...
                     {'A', 'B'}; ...
                     {}};
                 
    case 11021    %kg: Kerr + gate sweep
        name =      ["diode";    "waveform";  "voltmeter"; ...
                     "lockin";   "tempcont";  "magnet"; ...
                     "source";   "lockinA";   "lockinB"];
        driver =    ["ILX3724"; "A33220A";  "Keithley2182A"; ...
                     "SR844";    "LSCI331";    "KEPCO"; ...
                     "Keithley2401"; "SR830"; "SR830"];
        interface = ["gpib";    "gpib";     "gpib"; ...
                     "gpib";    "gpib";     "visa"; ...
                     "gpib";    "gpib";     "gpib"];
        address =   [15;        19;         17; ...
                     9;         23;        5;  ...
                     24;        12;         30];
        parameters = ...
                    {{}; ...
                     {}; ...
                     {nan}; ...
                     {}; ...
                     {nan}; ...
                     {}};
        fields =    {{'current', 'voltage', 'temperature'}; ...
                     {nan}; ...
                     {'v1'}; ...
                     {'X', 'Y', 'R', 'Q', 'AUX1', 'AUX2'}; ...
                     {'A', 'B'}; ...
                     {}};

    case 1290848    %kth: Kerr, transport, hall
        name =      ["voltmeter";    ...
                     "lockin";       ...
                     "tempcont";     ...
                     "magnet";       ...
                     "lockinA";]; 
        driver =    ["Keithley2182A";...
                     "SR844";        ...
                     "LSCI331";      ...
                     "KEPCO";        ...
                     "SR830";];
        interface = ["gpib";         ...
                     "gpib";         ...
                     "gpib";         ...
                     "visa";         ...
                     "gpib";];
        address =   [17;             ...
                     9;              ...
                     23;             ...
                     5;              ...
                     12;];
        parameters = ...
                    {{nan}; ...
                     {}; ...
                     {nan}; ...
                     {}; ...
                     {}};
        fields =    {{'v1'}; ...
                     {'X', 'Y', 'AUX1', 'AUX2'}; ...
                     {'A', 'B'}; ...
                     {}; ...
                     {'X', 'Y'}};
                 
    case 1228788    %ktc: Kerr, transport, capacitance
        name =      ["voltmeter";    ...
                     "lockin";       ...
                     "tempcont";     ...
                     "magnet";       ...
                     "lockinA";      ...
                     "bridge"]; 
        driver =    ["Keithley2182A";...
                     "SR844";        ...
                     "LSCI331";      ...
                     "KEPCO";        ...
                     "SR830";        ...
                     "AH2500A"];
        interface = ["gpib";         ...
                     "gpib";         ...
                     "gpib";         ...
                     "visa";         ...
                     "gpib";         ...
                     "gpib"];
        address =   [17;             ...
                     9;              ...
                     23;             ...
                     5;              ...
                     12;            ...
                     28];
        parameters ={{nan}; ...
                     {}; ...
                     {nan}; ...
                     {nan}; ...
                     {}; ...
                     {nan}};
        fields =    {{'v1'}; ...
                     {'X', 'Y', 'AUX1', 'AUX2'}; ...
                     {'A', 'B'}; ...
                     {}; ...
                     {'X', 'Y', 'AUXV1'}; ...
                     {'C'}};
    
    case 1278436    %ktg: Kerr, transport, gate
        name =      ["diode";       "waveform";     "voltmeter";    ...
                     "lockin";      "tempcont";     "magnet";       ...
                     "lockinA";     "lockinB";      "source"]; 
        driver =    ["ILX3724";     "A33220A";      "Keithley2182A";...
                     "SR844";       "LSCI331";      "KEPCO";        ...
                     "SR830";       "SR830";        "Keithley2401"];
        interface = ["gpib";        "gpib";         "gpib";         ...
                     "gpib";        "gpib";         "visa";         ...
                     "gpib";        "gpib";         "gpib"];
        address =   [15;            19;             17;             ...
                     9;             23;             5;              ...
                     12;            30;             24];
        parameters = ...
                    {{}; ...
                     {}; ...
                     {nan}; ...
                     {}; ...
                     {nan}; ...
                     {}; ...
                     {nan}; ...
                     {nan}; ...
                     {nan}};
        fields =    {{'current', 'voltage', 'temperature'}; ...
                     {nan}; ...
                     {'v1'}; ...
                     {'X', 'Y', 'R', 'Q', 'AUX1', 'AUX2'}; ...
                     {'A', 'B'}; ...
                     {}; ...
                     {'X', 'Y', 'R', 'Q', 'amplitude'}; ...
                     {'X', 'Y', 'R', 'Q', 'amplitude'}; ...
                     {'source', 'V', 'I'}};
                 
    case 12412      %tk: Kerr effect (time only)
        name =      ["diode";   "waveform"; "voltmeter";        "lockin"];
        driver =    ["ILX3724"; "A33220A";  "Keithley2182A";    "SR844"];
        interface = ["gpib";    "gpib";     "gpib";             "gpib"];
        address =   [15;        19;         17;                 9];
        parameters = ...
                    {{}; ...
                     {}; ...
                     {nan}; ...
                     {}};
        fields =    {{'current', 'voltage', 'temperature'}; ...
                     {nan}; ...
                     {'v1'}; ...
                     {'X', 'Y', 'R', 'Q', 'AUX1', 'AUX2'}};
                 
    case 14520      %xy: Kerr XY scan
        name =      ["voltmeter";        "lockin";   "X";       "Y"];
        driver =    ["Keithley2182A";    "SR844";    "Agilis";  "Agilis"];
        interface = ["gpib";             "gpib";     "serial";  "serial"];
        address =   [17;                 9;          5;         6];
        parameters = ...
                    {{nan}; ...
                     {}; ...
                     {nan}; ...
                     {nan}};
        fields =    {{'v1'}; ...
                     {'X', 'Y', 'R', 'Q', 'AUX1', 'AUX2'}; ...
                     {'position'}; ...
                     {'position'}};
                 
    case 120      %x: Kerr X scan
        name =      ["diode";   "waveform"; "voltmeter";        "lockin";   "X";    "Y"];
        driver =    ["ILX3724"; "A33220A";  "Keithley2182A";    "SR844";    "Agilis";   "Agilis"];
        interface = ["gpib";    "gpib";     "gpib";             "gpib";     "serial";   "serial"];    % FIXME
        address =   [15;        19;         17;                 9;          5;          6];
        parameters = ...
                    {{}; ...
                     {}; ...
                     {nan}; ...
                     {}; ...
                     {nan}; ...
                     {nan}};
        fields =    {{}; ...
                     {nan}; ...
                     {'v1'}; ...
                     {'X', 'Y', 'R', 'Q', 'AUX1', 'AUX2'}; ...
                     {'position'}; ...
                     {'position'}};
                 
    case 11600     %td: dc voltage (time only)
        name =      ["diode";   "waveform"; "voltmeter";        "lockin"];
        driver =    ["ILX3724"; "A33220A";  "Keithley2182A";    "SR844"];
        interface = ["gpib";    "gpib";     "gpib";             "gpib"];
        address =   [15;        19;         17;                 9];
        parameters = ...
                    {{}; ...
                     {}; ...
                     {nan}; ...
                     {}};
        fields =    {{'current', 'voltage', 'temperature'}; ...
                     {nan}; ...
                     {'v1'}; ...
                     {'X', 'Y', 'R', 'Q', 'AUX1', 'AUX2'}};
    
    case 9900     %dc: dc voltage (LARGE number)
        name =      ["diode";   "waveform"; "voltmeter";        "lockin"];
        driver =    ["ILX3724"; "A33220A";  "Keithley2182A";    "SR844"];
        interface = ["gpib";    "gpib";     "gpib";             "gpib"];
        address =   [15;        19;         17;                 9];
        parameters = ...
                    {{}; ...
                     {}; ...
                     {nan}; ...
                     {}};
        fields =    {{'current', 'voltage', 'temperature'}; ...
                     {nan}; ...
                     {'v1'}; ...
                     {'X', 'Y', 'R', 'Q', 'AUX1', 'AUX2'}};
    
    case 121    %y: Hysteresis in Kerr signal
        name =      ["diode";   "waveform"; "voltmeter";        "lockin";   "tempcont";   "magnet"];
        driver =    ["ILX3724"; "A33220A";  "Keithley2182A";    "SR844";    "LSCI331";    "KEPCO"];
        interface = ["gpib";    "gpib";     "gpib";             "gpib";     "gpib";       "visa"];
        address =   [15;        19;         17;                 9;          23;           5];
        parameters = ...
                    {{}; ...
                     {}; ...
                     {nan}; ...
                     {}; ...
                     {nan}; ...
                     {}};
        fields =    {{'current', 'voltage', 'temperature'}; ...
                     {nan}; ...
                     {'v1'}; ...
                     {'X', 'Y', 'R', 'Q', 'AUX1', 'AUX2'}; ...
                     {'A', 'B'}; ...
                     {}};
                 
    case 105    %i: Laser intensity sweep
        name =      ["diode";   "waveform"; "voltmeter";        "lockin";   "tempcont";   "magnet"];
        driver =    ["ILX3724"; "A33220A";  "Keithley2182A";    "SR844";    "LSCI331";    "KEPCO"];
        interface = ["gpib";    "gpib";     "gpib";             "gpib";     "gpib";       "visa"];
        address =   [15;        19;         17;                 9;          23;           5];
        parameters = ...
                    {{}; ...
                     {}; ...
                     {nan}; ...
                     {}; ...
                     {nan}; ...
                     {}};
        fields =    {{'current', 'voltage', 'temperature'}; ...
                     {nan}; ...
                     {'v1'}; ...
                     {'X', 'Y', 'R', 'Q', 'AUX1', 'AUX2'}; ...
                     {'A', 'B'}; ...
                     {}};
                 
    case 102    %f: Mod freq sweep
        name =      ["diode";   "waveform"; "voltmeter";        "lockin";   "magnet"];
        driver =    ["ILX3724"; "A33220A";  "Keithley2182A";    "SR844";    "KEPCO"];
        interface = ["gpib";    "gpib";     "gpib";             "gpib";     "visa"];
        address =   [15;        19;         17;                 9;          5];
        parameters = ...
                    {{}; ...
                     {}; ...
                     {nan}; ...
                     {}; ...
                     {}};
        fields =    {{'current', 'voltage', 'temperature'}; ...
                     {'freq', 'ampl'}; ...
                     {'v1'}; ...
                     {'X', 'Y', 'R', 'Q', 'AUX1', 'AUX2'}; ...
                     {}};
                 
    case 97    %a: Mod amplitude sweep
        name =      ["diode";   "waveform"; "voltmeter";        "lockin";   "magnet"];
        driver =    ["ILX3724"; "A33220A";  "Keithley2182A";    "SR844";    "KEPCO"];
        interface = ["gpib";    "gpib";     "gpib";             "gpib";     "visa"];
        address =   [15;        19;         17;                 9;          5];
        parameters = ...
                    {{}; ...
                     {}; ...
                     {nan}; ...
                     {}; ...
                     {}};
        fields =    {{'current', 'voltage', 'temperature'}; ...
                     {'freq', 'ampl'}; ...
                     {'v1'}; ...
                     {'X', 'Y', 'R', 'Q', 'AUX1', 'AUX2'}; ...
                     {}};
                 
    case 9894   %fa: Mod freq and amplitude sweep
        name =      ["diode";   "waveform"; "voltmeter";        "lockin";   "magnet"];
        driver =    ["ILX3724"; "A33220A";  "Keithley2182A";    "SR844";    "KEPCO"];
        interface = ["gpib";    "gpib";     "gpib";             "gpib";     "visa"];
        address =   [15;        19;         17;                 9;          5];
        parameters = ...
                    {{}; ...
                     {}; ...
                     {nan}; ...
                     {}; ...
                     {}};
        fields =    {{}; ...
                     {'freq', 'ampl'}; ...
                     {'v1'}; ...
                     {'X', 'Y', 'R', 'Q', 'AUX1', 'AUX2'}; ...
                     {}};
        
    case 68     %D: Diode temperature
        name =      "diode";
        driver =    "ILX3724";
        interface = "visa";
        address =   15;
        parameters ={{}};
        fields =    {{'temperature', 'resistance'}};
        
    case 114    %r: Single transport lockin
        name =      "lockin";
        driver =    "SR830";
        interface = "visa";
        address =   30;
        parameters ={{}};
        fields =    {{'X', 'Y', 'R', 'Q'}};
        
    case 11832  %tf: Transport freq sweep
        name =      "lockin";
        driver =    "SR830";
        interface = "visad";
        address =   12;
        parameters ={{}};
        fields =    {{'f', 'X', 'Y', 'R', 'Q'}};
        
    case 116    %t: Two transport lockins & temperature controller
        name =      ["lockinB";  "tempcont"];
        driver =    ["SR830";    "LSCI331"];
        interface = ["visadev";  "visa"];
        address =   [12;        30;         23];
        parameters = ...
                    {{}; ...
                     {'frequency', 'phase', 'timeConstant'}; ...
                     {nan}};
        fields =    {{'X', 'Y', 'R', 'Q'}; ...
                     {'X', 'Y'}; ...
                     {}};
                 
    case 11948    %tg: Two transport lockins & gate voltage controller
        name =      ["lockinA"; "lockinB";  "source"];
        driver =    ["SR830";   "SR830";    "Keithley2401"];
        interface = ["gpib";    "gpib";     "gpib"];
        address =   [12;        30;         24];
        parameters = ...
                    {{}; ...
                     {}; ...
                     {nan}};
        fields =    {{'X', 'Y', 'R', 'Q', 'amplitude'}; ...
                     {'X', 'Y', 'R', 'Q', 'amplitude'}; ...
                     {'source', 'V', 'I'}};
                 
    case 104    %h: Hall effect measurement
        name =      ["lockinA"; "lockinB";  "tempcont"; "magnet"];
        driver =    ["SR830";   "SR830";    "LSCI331";  "KEPCO"];
        interface = ["visa";    "visa";     "visa";     "visa"];
        address =   [12;        30;         23;         5];
        parameters = ...
                    {{}; ...
                     {}; ...
                     {}; ...
                     {}};
        fields =    {{'X', 'Y', 'R', 'Q'}; ...
                     {'X', 'Y'}; ...
                     {}; ...
                     {}};
                 
    case 112    %p: Optical power measurement with Newport 1830-C
        name =      ["diode";   "powermeter"];
        driver =    ["ILX3724"; "Newport1830"];
        interface = ["visa";    "gpib"];
        address =   [15;        13];
        parameters = ...
                    {{}; ...
                     {nan}};
        fields =    {{'current', 'voltage', 'temperature'}; ...
                     {}};
                 
    case 100    %d: DC voltage with Keithley 2182A
        name =      ["diode";   "voltmeter"];
        driver =    ["ILX3724"; "Keithley2182A"];
        interface = ["visa";    "gpib"];
        address =   [15;        17];
        parameters = ...
                    {{}; ...
                     {nan}};
        fields =    {{'current', 'voltage', 'temperature'}; ...
                     {'v1'}};
                 
    case 477128    %LIV: DC voltage with Keithley 2182A
        name =      ["diode";   "voltmeter"];
        driver =    ["ILX3724"; "Keithley2182A"];
        interface = ["visa";    "gpib"];
        address =   [15;        17];
        parameters = ...
                    {{}; ...
                     {nan}};
        fields =    {{'current', 'voltage', 'temperature'}; ...
                     {'v1'}};             
    
    case 119    %w: wavelength sweep Newport 1830-C
        name =      ["diode";   "powermeter"];
        driver =    ["ILX3724"; "Newport1830"];
        interface = ["visa";    "gpib"];
        address =   [15;        13];
        parameters = ...
                    {{}; ...
                     {nan}};
        fields =    {{'current'}; ...
                     {'wavelength', 'power'}};
                 
    case 11960    %hs: Hall sensor
        name =      ["magnet";  "voltmeter"];
        driver =    ["KEPCO";   "Keithley2182A"];
        interface = ["visa";    "gpib"];
        address =   [5;         17];
        parameters = ...
                    {{}; ...
                     {nan}};
        fields =    {{'I', 'V'}; ...
                     {'v1', 'v2'}};
                 
    case 11682  %cv: capacitance vs voltage
        name =      ["bridge";  "lockin"];
        driver =    ["AH2500A";   "SR830"];
        interface = ["visa";    "visa"];
        address =   [28;         12];
        parameters = ...
                    {{nan}; ...
                     {nan}};
        fields =    {{'C'}; ...
                     {'AUXV1'}};
                 
    case 10593  %kc: kerr vs strain (capacitance)
        name =      ["bridge";  "lockin";   "lockinA";  "voltmeter";];
        driver =    ["AH2500A"; "SR844";    "SR830";    "Keithley2182A"];
        interface = ["visa";    "gpib";     "visa";     "gpib"];
        address =   [28;         9;         12;         17];
        parameters = ...
                    {{nan}; ...
                     {}; ...
                     {nan}; ...
                     {nan}};
        fields =    {{'C'}; ...
                     {'X', 'Y', 'R', 'Q', 'AUX1', 'AUX2'}; ...
                     {'X', 'AUXV1'}; ...
                     {'v1'}};
                 
    case 117    % 'u'
        %Do nothing. User will create schema.
        schema = table();
        return
    otherwise
        disp("[make.schema] Unkown experiment configuration.");
        name =      "tempcont";
        driver =    "LSCI331";
        interface = "visa";
        address =   23;
        parameters = {{nan}};
        fields =    {{}};
end

schema = table(name, driver, interface, address, parameters, fields);
writetable(schema, sprintf("schema-%d.csv", key));
