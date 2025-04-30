function s = schema()
%Create and save table with instrument information for a given experiment.

    name =      ["lockin";   "X"];
    driver =    ["HF2LI";    "KDC101"];
    interface = ["ziDAQ";    "Kinesis"];
    address =   [NaN;         27006521];
    parameters = ...
                {{}; ...                
                {nan}};
    fields =    {{'sample'}; ...
                {'position'}};

    s = table(name, driver, interface, address, parameters, fields);

    % Custom properties
    s = addprop(s,{'Seed', 'SourceFile', 'ExperimentDescription'}, {'table', 'table', 'table'});
    s.Properties.CustomProperties.SourceFile = string(mfilename('fullpath'));
    s.Properties.CustomProperties.ExperimentDescription = "Kerr vs X coordinate (KDC101).";
end
    