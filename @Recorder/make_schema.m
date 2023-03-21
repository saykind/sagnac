function schema = make_schema(seed)
%Create and save table with instrument information
%   seed:
%       T -- LSCI331[23].
%       r -- SR830[12], LSCI331[23].
%       t -- SR830[12], SR830[30], LSCI331[23].

if nargin < 1, seed = '0'; end

switch seed
    case 'T'
        name =      "tempcont";
        driver =    "LSCI331";
        interface = "visa";
        address =   23;
        parameters = {{nan}};
        fields =    {{}};
    case 'r'
        name =      "lockin";
        driver =    "SR830";
        interface = "visadev";
        address =   30;
        parameters ={{}};
        fields =    {{'X', 'Y', 'R', 'Q'}};
    case 't'
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
    case 'h'
        name =      ["lockinA"; "lockinB";  "tempcont"; "magnet"];
        driver =    ["SR830";   "SR830";    "LSCI331";  "KEPCO"];
        interface = ["visadev"; "visadev";  "visa";     "visadev"];
        address =   [12;        30;         23;         5];
        parameters = ...
                    {{}; ...
                     {'frequency', 'phase', 'timeConstant'}; ...
                     {nan}; ...
                     {}};
        fields =    {{'X', 'Y', 'R', 'Q'}; ...
                     {'X', 'Y'}; ...
                     {}; ...
                     {}};
    case 'u'
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
writetable(schema, sprintf("schema-%c.csv", seed));
