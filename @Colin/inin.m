function instr = inin(obj, instr)
% Instrument initialization function.
    arguments
        obj;
        instr struct = struct();
    end
    [obj.instruments, instr] = make.instruments(obj.schema, instr); 

    obj.logdata = pull.logdata(obj.instruments, obj.schema);
    obj.loginfo = pull.loginfo(obj.instruments, obj.schema);
end