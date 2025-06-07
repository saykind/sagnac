function s = schema()
%Create and save table with instrument information for a given experiment.

    name =      ["tempcont";     "lockinA";     "lockinB"];
    driver =    ["LSCI331";      "SR830";       "SR830"];
    interface = ["gpib";         "gpib";        "gpib"];
    address =   [23;              12;            30];
    parameters = ...
                {{nan}; ...
                {'amplitude', 'phase', 'frequency', 'timeConstant'}; ...
                {'amplitude', 'phase', 'frequency', 'timeConstant'}};
    fields =    {{'A', 'B'}; ...
                {'X', 'Y', 'amplitude'}; ...
                {'X', 'Y'}};

    s = table(name, driver, interface, address, parameters, fields);

    % Custom properties
    s = addprop(s,{'Seed', 'SourceFile', 'ExperimentDescription'}, {'table', 'table', 'table'});
    s.Properties.CustomProperties.SourceFile = string(mfilename('fullpath'));
    s.Properties.CustomProperties.ExperimentDescription = "Resistance vs input current (ohmic test).";
end
