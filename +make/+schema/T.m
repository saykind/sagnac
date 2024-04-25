function schema = T()
%Create and save table with instrument information for a given experiment.

    name =      "tempcont";
    driver =    "LSCI331";
    interface = "visa";
    address =   23;
    parameters = {{nan}};
    fields =    {{}};

    schema = table(name, driver, interface, address, parameters, fields);
    schema.Properties.Description = mfilename;
end
