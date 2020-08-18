function obj = save(obj)
    %Write data to obj.path file
    
    if isempty(obj.path)
        return
    end
    
    data = obj.data;
    save(obj.path, '-struct', 'data');
end