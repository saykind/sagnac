function T = instrumentarium(num)
%Create and save table with instrument information
%   num:
%       1 -- Simple Kerr expreiment
%       2 -- Kerr measurement and transport
%       3 -- Simple Transport

if ~nargin, num = 3; end

if num == 1
    T = table();
end

if num == 3
    name =      ["lockinA"; "lockinB";  "tempcont"; "magnet"];
    driver =    ["SR830";   "SR830";    "LSCI331";  "KEPCO"];
    interface = ["gpib";    "gpib";     "visa";     "gpib"];
    address =   [12;        30;         23;         5];
    parameters = ...
        {{}; ...
         {'frequency', 'phase', 'time constant'}; ...
         {nan}; ...
         {}};
    fields =    {{'X', 'Y'}; ...
                 {'X', 'Y'}; ...
                 {'A', 'B'}; ...
                 {'I', 'V'}};
    T = table(name, driver, interface, address, parameters, fields);
end

writetable(T, sprintf("instrumentarium%d.csv", num));
