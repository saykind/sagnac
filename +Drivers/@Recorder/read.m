function obj = read(obj)
    %Read instrument values
    
    i = obj.counter;
    t = obj.timeStep*i;
    obj.data.logdata.time(i) = t;
    
    for instrumentCell = obj.instruments
        instrument = instrumentCell{1};
        for field = instrument.fields
            obj.data.logdata.(instrument.idn).(field{:})(i) ...
                = instrument.read(field{:});
        end
    end
end