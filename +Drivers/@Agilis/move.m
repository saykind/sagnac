function out = move(obj, shift)
    %Move by shift [mm] relative to current position
    
    %Cheack if new position is valid
    position = obj.get('position');
    new_position = position + shift;
    if new_position < -13
        warning("New position is below lower limit. Going to 0 instead.");
        obj.set('position', 0);
    end
    if new_position > 27
        warning("New position is above high limit. Going to 0 instead.");
        obj.set('position', 27);
    end
    
    obj.write(sprintf("1PR%.4f", shift));
    if obj.wait
        for i=1:200
            java.lang.Thread.sleep(100); % 15 millisec accuracy
            if ~strcmp(obj.st(), "MOVING")
                break
            end
        end
        obj.st();
        obj.ps();
    else
        obj.position = new_position;
    end
    out = obj.get('error');
end