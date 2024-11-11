function s = schema()
%Create and save table with instrument information for a given experiment.

    name =      ["lockin";   "Z"];
    driver =    ["HF2LI";    "Manual"];
    interface = ["ziDAQ";    ""];
    address =   [NaN;        NaN];
    parameters = ...
                {{}; ...
                {nan}};
    fields =    {{'sample'}; ...
                {'position'}};

    s = table(name, driver, interface, address, parameters, fields);

    % Custom properties
    s = addprop(s,{'Seed', 'SourceFile', 'ExperimentDescription'}, {'table', 'table', 'table'});
    s.Properties.CustomProperties.SourceFile = string(mfilename('fullpath'));
    s.Properties.CustomProperties.ExperimentDescription = "Kerr vs z-position.";
end
    