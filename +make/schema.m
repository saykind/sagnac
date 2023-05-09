function schema = schema(key)
%Create and save table with instrument information
%   seed:
%        84 T -- LSCI331[23].
%       114 r -- SR830[12], LSCI331[23].
%       116 t -- SR830[12], SR830[30], LSCI331[23].
%       112 p -- Optical power
%       100 d -- DC voltage
%       119 w -- wavelength sweep on Optical power detector

if nargin < 1, key = 0; end

switch key
    case 84     % 'T' Single temperature controller
        name =      "tempcont";
        driver =    "LSCI331";
        interface = "visa";
        address =   23;
        parameters = {{nan}};
        fields =    {{}};
        
    case 114    % 'r' Single transport lockin
        name =      "lockin";
        driver =    "SR830";
        interface = "visad";
        address =   30;
        parameters ={{}};
        fields =    {{'X', 'Y', 'R', 'Q'}};
        
    case 116    % 't' Two transport lockins & temperature controller
        name =      ["lockinA"; "lockinB";  "tempcont"];
        driver =    ["SR830";   "SR830";    "LSCI331"];
        interface = ["visadev"; "visadev";  "visa"];
        address =   [12;        30;         23];
        parameters = ...
                    {{}; ...
                     {'frequency', 'phase', 'timeConstant'}; ...
                     {nan}};
        fields =    {{'X', 'Y', 'R', 'Q'}; ...
                     {'X', 'Y'}; ...
                     {}};
                 
    case 104    % 'h' Hall effect measurement
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
                 
    case 112    % 'p' Optical power measurement with Newport 1830-C
        name =      ["diode";   "powermeter"];
        driver =    ["ILX3724"; "Newport1830"];
        interface = ["visa";    "gpib"];
        address =   [15;        13];
        parameters = ...
                    {{}; ...
                     {nan}};
        fields =    {{'current', 'voltage', 'temperature'}; ...
                     {}};
                 
    case 100    % 'd' DC voltage with Keithley 2182A
        name =      ["diode";   "voltmeter"];
        driver =    ["ILX3724"; "Keithley2182A"];
        interface = ["visa";    "gpib"];
        address =   [15;        17];
        parameters = ...
                    {{}; ...
                     {nan}};
        fields =    {{'current', 'voltage', 'temperature'}; ...
                     {'v1'}};
    
    case 119    % 'w' wavelength sweep Newport 1830-C
        name =      ["diode";   "powermeter"];
        driver =    ["ILX3724"; "Newport1830"];
        interface = ["visa";    "gpib"];
        address =   [15;        13];
        parameters = ...
                    {{}; ...
                     {nan}};
        fields =    {{'current'}; ...
                     {'wavelength', 'power'}};
                 
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
writetable(schema, sprintf("schema-%c.csv", key));
