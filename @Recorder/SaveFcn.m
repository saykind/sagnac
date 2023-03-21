function obj = SaveFcn(obj, event)
    %Write data to obj.filename file
    
    if isempty(obj.filename)
        disp("Please provide datafilename.");
        return
    end
    
    data = struct('title', obj.title, ...
        'readme', obj.readme, ...
        'info', obj.info, ...
        'logdata', obj.logdata);
    save(obj.filename, '-struct', 'data');
    
    fprintf('[%s] saved to %s (%s).\n', obj.title, obj.filename, ...
        datestr(event.Data.time, 'HH:MM:SS'));
end