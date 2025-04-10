function s = schema()
%Create and save table with instrument information for a given experiment.

    name =      ["lockin";   "X";       "Y"];
    driver =    ["HF2LI";    "Agilis";  "Agilis"];
    interface = ["ziDAQ";    "serial";  "serial"];
    address =   [NaN;        5;         6];
    parameters = ...
                {{}; ...                
                {nan}; ...
                {nan}};
    fields =    {{'sample'}; ...
                {'position'}; ...
                {'position'}};

    s = table(name, driver, interface, address, parameters, fields);

    % Custom properties
    s = addprop(s,{'Seed', 'SourceFile', 'ExperimentDescription'}, {'table', 'table', 'table'});
    s.Properties.CustomProperties.SourceFile = string(mfilename('fullpath'));
    s.Properties.CustomProperties.ExperimentDescription = "Kerr vs XY coordinates (agilis).";
end
    