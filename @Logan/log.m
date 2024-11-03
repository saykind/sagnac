function log(obj)
    %Reads instrumets' fields and saves them into logdata.
    
    if isempty(obj.instruments), util.msg("Instruments are missing."); return; end
    if isempty(obj.schema), util.msg("Schema is missing."); return; end
    
    names = obj.schema.name;
    for i = 1:numel(names)
        name = names{i};
        instrument = obj.instruments.(name);
    
        fields = obj.schema.fields{i};
        if isempty(fields), fields = instrument.fields; end
        if isempty(fields), continue; end
        if isnan(fields{1}), continue; end
        for j = 1:numel(fields)
            field = fields{j};
            dat = 0;
            try
                dat = instrument.get(field);
            catch
                util.msg("Failed to get %s.%s data.\n", name, field);
            end
            if obj.verbose > 100
                fprintf("%s.%s : %f\n", name, field, dat);
            end
            obj.logdata.(name).(field) = [obj.logdata.(name).(field); dat];
        end
    end
    
    