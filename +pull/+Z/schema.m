function s = schema()
%Create and save table with instrument information for a given experiment.

    name =      "lockin";
    driver =    "HF2LI";
    interface = "ziDAQ";
    address =   18120;
    parameters = {{}};
    fields =    {{'sample', 'output_amplitude'}};

    s = table(name, driver, interface, address, parameters, fields);

    % Custom properties
    s = addprop(s,{'Seed', 'SourceFile', 'ExperimentDescription'}, {'table', 'table', 'table'});
    s.Properties.CustomProperties.SourceFile = string(mfilename('fullpath'));
    s.Properties.CustomProperties.ExperimentDescription = "Kerr vs time.";
end
