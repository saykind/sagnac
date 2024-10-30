function schema = r2l()
%Create and save table with instrument information for a given experiment.

    name =      ["lockinA"; "lockinB";  "tempcont"; "temp"];
    driver =    ["SR830";   "SR830";    "LSCI331";  "LSCI340"];
    interface = ["visa";    "visa";     "visa";     "visa"];
    address =   [12;        30;         23;         16];
    parameters = {{'f'};    {'f'};    {nan};        {nan}};
    fields =    {{'X', 'Y', 'a'};  {'X', 'Y', 'a'};  {'A', 'B'};    {'A', 'B'}};

    schema = table(name, driver, interface, address, parameters, fields);
    schema.Properties.Description = mfilename;
end
