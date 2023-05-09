function schema = make_schema(key)
%Create and save table with instrument information
%   seed:
%       T -- LSCI331[23].
%       r -- SR830[12], LSCI331[23].
%       t -- SR830[12], SR830[30], LSCI331[23].

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
    case 117    % 'u'
        %Do nothing. User will create schema.
        schema = table();
        return
    otherwise
        disp("[make_schema] Unkown experiment configuration.");
        name =      "tempcont";
        driver =    "LSCI331";
        interface = "visa";
        address =   23;
        parameters = {{nan}};
        fields =    {{}};
end

schema = table(name, driver, interface, address, parameters, fields);
writetable(schema, sprintf("schema-%c.csv", key));
