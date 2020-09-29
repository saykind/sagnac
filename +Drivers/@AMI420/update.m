function obj = update(obj)
%Self-read field values.
    fn = fieldnames(obj);
    fields = fn(7:end);
    obj.read(fields{:});
end