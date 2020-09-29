function obj = ramp(obj)
%Switch between ramp and pause states
    
    if strcmp(obj.read('state'), 'paused')
        fprintf(obj.handle, 'ramp');
    else
        fprintf(obj.handle, 'pause');
    end
end