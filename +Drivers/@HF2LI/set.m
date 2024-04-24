function set(obj, options)
    %Parameter set method
    %
    %   Usage example:
    %   obj.set('frequency', 5e6);
    %   obj.set('f', [5e6, 4.836e6], 'tc', [1, 1, 1, .3, .3, .3]);

    arguments
        obj Drivers.HF2LI;
        options.input_range double = [];
        options.frequency double = [];
        options.phase double = [];
        options.time_constant double = [];
        options.range double = [];
        options.amplitude double = [];
    end
   
    
    % Set values
    if ~isempty(options.input_range)
        range = options.input_range;
        if numel(range) > obj.num_inputs
            error('The number of input ranges must be smaller then the number of inputs.');
        end
        if numel(range) < obj.num_inputs
            range = [range, range(end)*ones(1, obj.num_inputs - numel(range))];
        end
        for j = 1:obj.num_inputs
            ziDAQ('setDouble', ['/' obj.id '/sigins/' num2str(j-1) '/range'], range(j));
        end
    end
    

    % Syncronize all data paths.
    ziDAQ('sync');
end