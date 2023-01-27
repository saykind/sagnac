function state = ready(obj)
%Going to READY state from NOT REFERENCED or from DISABLE
    state = obj.st();
    if strcmp(state, "NOT REFERENCED")
        obj.write("1OR");
        if obj.wait
            for i=1:200
                java.lang.Thread.sleep(100); % 15 millisec accuracy
                if ~strcmp(obj.st(), "HOMING")
                    break
                end
            end
            obj.st();
            obj.ps();
        end
        state = obj.st();
        return
    end
    if strcmp(state, "DISABLE")
        obj.write("1MM1");
        state = obj.st();
        return
    end
end