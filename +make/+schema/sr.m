function schema = sr()
%Create and save table with instrument information for a given experiment.

    name =      ["lockin";  "tempcont"];
    driver =    ["SR830";  "LSCI331"];
    interface = ["visa";   "visa"];
    address =   [12;    23];
    parameters = {{nan};    {nan}};
    fields =    {{'X', 'Y', 'AUXV1'};   {}};

    schema = table(name, driver, interface, address, parameters, fields);
    schema.Properties.Description = mfilename;
end
