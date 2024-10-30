function schema = bcb()
%Create and save table with instrument information for a given experiment.

    name =      "bcb";
    driver =    "BCB";
    interface = "serial";
    address =   7;
    parameters = {{'mode', 'vpi'}};
    fields =    {{'voltage', 'optical_power'}};

    schema = table(name, driver, interface, address, parameters, fields);
    schema.Properties.Description = mfilename;
end
