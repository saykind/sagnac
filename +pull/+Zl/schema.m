function s = schema()
%Create and save table with instrument information for a given experiment.

    name =      ["lockin";  "laser"];
    driver =    ["HF2LI";   "ILX3724"];
    interface = ["ziDAQ";   "visa"];
    address =   [NaN;       15];
    parameters = {...
                {}; ...
                {nan} ...
                };
    fields =    { ...
                {'sample', 'output_amplitude'}; ...
                {'I'} ...
                };

    s = table(name, driver, interface, address, parameters, fields);

    % Custom properties
    s = addprop(s,{'Seed', 'SourceFile', 'ExperimentDescription'}, {'table', 'table', 'table'});
    s.Properties.CustomProperties.SourceFile = string(mfilename('fullpath'));
    s.Properties.CustomProperties.ExperimentDescription = "Kerr vs diode current.";
end
    