function info = available() 
% Make a table with available experiment labels (seeds).

    % get dir of this file
    folder = fileparts(mfilename('fullpath'));

    folders = dir(fullfile(folder, '+*'));
    seed = {folders.name};
    seed = cellfun(@(x) x(2:end), seed, 'UniformOutput', false);
    seed = string(seed)';
    devices = strings(numel(seed), 1);
    description = strings(numel(seed), 1);

    % Load corresponding schema
    for i = 1:numel(seed)
        try
            schema = pull.(seed(i)).schema;
            names = strcat(schema.name, ", ");
            names = [names{:}];
            devices(i) = string(names(1:end-2));
            description(i) = schema.Properties.CustomProperties.ExperimentDescription;
        catch ME
            util.msg("Failed to load [%s] schema", seed);
            util.msg(ME.message);
        end
    end

    % Make table with variables 'seed' and 'devices'
    info = table(seed, devices, description);
end