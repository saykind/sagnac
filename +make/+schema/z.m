function schema = z()
%Create and save table with instrument information for a given experiment.

    name =      "lockin";
    driver =    "HF2LI";
    interface = "ziDAQ";
    address =   NaN;
    parameters = {{nan}};
    fields =    {{'x', 'y'}};

    schema = table(name, driver, interface, address, parameters, fields);
    schema.Properties.Description = mfilename;
end
