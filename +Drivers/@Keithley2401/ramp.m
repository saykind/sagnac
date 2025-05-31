function ramp(obj, V1, rate, period)
    %Ramp voltage to specified value 'V1' (Volts),
    %at specified 'rate' (V/sec),
    %changing voltage every 'period'.
    %Default 'rate' is 0.05 V/sec.
    %Deafult 'period' is 0.5 sec.
        if nargin < 2, return; end
        if nargin < 3, rate = 0.1; end
        if nargin < 4, period = .5; end
        
        util.timers.clearall(0, 'Keithley2401');
        
        obj.rampInfo = {};
        V0 = obj.get('volt');
        obj.rampInfo.V_initial = V0;
        obj.rampInfo.V_final = V1;
        obj.rampInfo.rate = rate;
        num = fix(abs(V1-V0)/rate)/period;
        if num < 1, num=1; end
        obj.rampInfo.V_num = num;
        obj.rampInfo.V_array = linspace(V0, V1, num);
        
        obj.ramper = timer('Tag', 'Keithley2401');
        obj.rampInfo.name = obj.ramper.Name;
        obj.ramper.Period = period;
        obj.ramper.TasksToExecute = num;
        obj.ramper.ExecutionMode = 'fixedRate';
        obj.ramper.StartDelay = period;
        %obj.ramper.StartFcn = @(~, event)obj.rampStart(event);
        obj.ramper.TimerFcn = @(~, event)obj.rampStep(event);
        obj.ramper.StopFcn = @(~, event)obj.rampStop(event);
        %obj.ramper.ErrorFcn = @(~, event)obj.rampStop(event);
        
        obj.ramper.start();
    end
    
