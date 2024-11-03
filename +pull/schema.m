function s = schema(seed)
% Retrieve schema based on seed string

    arguments
        seed string
    end
    
    try
        % Using seed-first hierarchy
        s = pull.(seed).schema;
    catch
        util.msg('pull.(%s).schema not found, trying legacy version', seed);
        try
            % Using legacy schema-first hierarchy
            s = make.schema.(seed);
        catch
            util.msg('make.schema.(%s) not found, interrupting...', seed);
            return;
        end
    end    

    % Add watch instrument to schema
    var_names = {'name', 'driver', 'interface', 'address', 'parameters', 'fields'};
    new_row = table("watch", "Watch", "datetime", NaN, {{'datetime'}}, {{'datetime'}}, ...
                    'VariableNames', var_names);
    s = [s; new_row];

    % Add description for each column
    s.Properties.VariableDescriptions = {'Internal (human) device name'; ...
                                        'Driver name / Factory instrument name'; ...
                                        'Interface type (GPIB/VISA/Serial Port)'; ...
                                        'Instrument address'; ...
                                        'Intrument parameters / settings'; ...
                                        'Instrument fields (recorded data)'};

    % Add seed label (extracted from fullpath)
    try
        fullpath = s.Properties.CustomProperties.SourceFile;
        [folder, ~, ~] = fileparts(fullpath);
        [~, folder, ~] = fileparts(folder);
        folder = [folder{:}];
        seed = folder(2:end);
        s.Properties.CustomProperties.Seed = seed;
    catch ME
        util.msg(ME.message);
    end

end