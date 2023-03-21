function T = schema(num)
%Create and save table with instrument information
%   num:
%       1 -- Simple Kerr expreiment.
%       2 -- Kerr measurement and transport.
%       3 -- Simple Transport (defualt).

if ~nargin, num = 3; end

if num == 1
    T = table();
end

if num == 3
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
    T = table(name, driver, interface, address, parameters, fields);
end


if num == 4
    name =      "lockin";
    driver =    "SR830";
    interface = "visadev";
    address =   30;
    parameters ={{}};
    fields =    {{'X', 'Y', 'R', 'Q'}};
    T = table(name, driver, interface, address, parameters, fields);
end

writetable(T, sprintf("schema-%d.csv", num));
