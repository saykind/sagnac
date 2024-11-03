function s = schema()
%Create and save table with instrument information for a given experiment.

    name =      "tempcont";
    driver =    "LSCI331";
    interface = "visa";
    address =   23;
    parameters = {{nan}};
    fields =    {{}};

    s = table(name, driver, interface, address, parameters, fields);

    % Custom properties
    s = addprop(s,{'Seed', 'SourceFile', 'ExperimentDescription'}, {'table', 'table', 'table'});
    s.Properties.CustomProperties.SourceFile = string(mfilename('fullpath'));
    s.Properties.CustomProperties.ExperimentDescription = "Temperature vs time.";
end
