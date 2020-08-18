function fieldNames = determine_field_names(logdata)
    %Kerr data analysis method
    %   Returns correct logdata structure field names.
    
    possibleFieldNames = struct(...
        'firstHarmonicX', ["firstX", "firstx", "first", "X"], ...
        'firstHarmonicY', ["firstY", "firsty", "Y"], ...
        'secondHarmonic',  ["second", "AUX1"], ...
        'temperature', ["temp", "temperature", "sampletemperature"], ...
        'time', ["time", "Time"], ...
        'kerr', ["kerr", "kerr2"]);
    
    fields = fieldnames(possibleFieldNames);
    numFields = numel(fields);
    fieldNames = cell2struct(cell(numFields, 1), fields);

    for i = 1:numFields
        field = fields{i};
        for fieldName = possibleFieldNames.(field)
            if isfield(logdata, fieldName)
                fieldNames.(field) = fieldName;
                break;
            end
        end
        if isempty(fieldNames.(field))
            fprintf("Field <<%s>> is not present.\n", field);
        end
    end
    
end 