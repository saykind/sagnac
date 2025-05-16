function s = schema()
%Create and save table with instrument information for a given experiment.

    name =      ["lockin";   "X";               "Y";        "lockinA"];
    driver =    ["HF2LI";    "KDC101";          "KDC101";   "SR830"];
    interface = ["ziDAQ";    "Kinesis";         "Kinesis";  "gpib"];
    address =   [NaN;         27006521;         27006520;    12];
    parameters = ...
                {{}; ...                
                {nan}; ...
                {nan}; ...
                {'amplitude', 'phase', 'frequency', 'timeConstant'}};
    fields =    {{'sample'}; ...
                {'position'}; ...
                {'position'}; ...
                {'X', 'Y', 'amplitude'}};

    s = table(name, driver, interface, address, parameters, fields);

    % Custom properties
    s = addprop(s,{'Seed', 'SourceFile', 'ExperimentDescription'}, {'table', 'table', 'table'});
    s.Properties.CustomProperties.SourceFile = string(mfilename('fullpath'));
    s.Properties.CustomProperties.ExperimentDescription = "DC, PG vs XY coordinates (KDC101).";
end
    