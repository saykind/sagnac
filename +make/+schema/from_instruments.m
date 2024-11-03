function schema = from_instruments(instruments)
    % Make table schema from instruments struct.
    arguments
        instruments (1,1) struct
    end

    schema = table();
    for name = fieldnames(instruments)'
        dev = instruments.(name{1});
        var_names = {'name', 'driver', 'interface', ...
                    'address', 'parameters', 'fields'};
        try
            new_row = table(string(name{1}), ...
                            dev.name, ...
                            dev.interface, ...
                            dev.address, ...
                            {{}}, ...
                            {{}}, ...
                            'VariableNames', var_names);
        catch err
            util.msg("%s\n", err.message);
            return
        end
        schema = [schema; new_row];
    end
end