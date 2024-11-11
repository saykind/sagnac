function logdata = logdata(instruments, schema)
%LOGDATA Create logdata structure with correct fields.

    if isempty(instruments), util.msg("Instruments are missing."); return; end
    if isempty(schema), util.msg("Schema is missing."); return; end

    logdata = struct();

    names = schema.name;
    for i = 1:numel(names)
        name = names{i};
        instrument = instruments.(name);

        fields = schema.fields{i};
        if isempty(fields), fields = instrument.fields; end
        if isempty(fields), continue; end
        if isnan(fields{1}), continue; end
        logdata.(name) = struct();
        for j = 1:numel(fields)
            field = fields{j};

            try
                dat = instrument.get(field);
            catch
                util.msg("Failed to get %s.%s data.\n", name, field);
            end

            if isstruct(dat)
                fns = fieldnames(dat);
                for k = 1:numel(fns)
                    fn = fns{k};
                    try
                        logdata.(name).(fn) = [];
                    catch
                        util.msg("Failed to get %s.%s data.\n", name, fn);
                    end
                end
            else
                logdata.(name).(field) = [];
            end

        end
end
