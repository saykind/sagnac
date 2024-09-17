function schema = rsv()
%Create and save table with instrument information for a given experiment.

    name =      "lockin";
    driver =    "SR830";
    interface = "visa";
    address =   12;
    parameters = {{nan}};
    fields =    {{'X', 'Y', 'AUXV1'}};

    schema = table(name, driver, interface, address, parameters, fields);
    schema.Properties.Description = mfilename;
end
