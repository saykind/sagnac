function s = schema()
%Create and save table with instrument information for a given experiment.

    name =      ["tempcont";     "lockinA";];
    driver =    ["LSCI331";      "SR830";];
    interface = ["gpib";         "visa";];
    address =   [23;              12;];
    parameters = ...
                {{nan}; ...
                {'amplitude', 'frequency'}};
    fields =    {{'A', 'B'}; ...
                {'X', 'Y', 'amplitude'}};

    s = table(name, driver, interface, address, parameters, fields);

    % Custom properties
    s = addprop(s,{'Seed', 'SourceFile', 'ExperimentDescription'}, {'table', 'table', 'table'});
    s.Properties.CustomProperties.SourceFile = string(mfilename('fullpath'));
    s.Properties.CustomProperties.ExperimentDescription = "Resistance vs input current (ohmic test).";
end
