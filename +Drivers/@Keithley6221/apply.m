function apply(obj, I1, rate, period)
    %Ramp current to specified value 'I1' (Amps),
    %at specified 'rate' (A/sec),
    %changing voltage every 'period'.
    %Default 'rate' is 1e-3 A/sec.
    %Deafult 'period' is 0.5 sec.
        if nargin < 2, return; end
        if nargin < 3, rate = 1e-3; end
        if nargin < 4, period = .5; end

        if abs(I1) > 8e-2
            error('Current limit exceeded. Maximum current is 80 mA.');
        end

        I0 = obj.get('current');
        if abs(I1-I0) < 1e-6
            return;
        end
        
        util.timers.clearall(0, obj.name);
        
        obj.rampInfo = {};
        obj.rampInfo.I_initial = I0;
        obj.rampInfo.I_final = I1;
        obj.rampInfo.rate = rate;
        num = fix(abs(I1-I0)/rate)/period+1;
        if num < 1, num=1; end
        obj.rampInfo.I_num = num;
        obj.rampInfo.I_array = linspace(I0, I1, num);
        
        obj.ramper = timer('Tag', obj.name);
        obj.rampInfo.name = obj.ramper.Name;
        obj.ramper.Period = period;
        obj.ramper.TasksToExecute = num;
        obj.ramper.ExecutionMode = 'fixedRate';
        obj.ramper.StartDelay = period;
        obj.ramper.StartFcn = @(~, event)obj.applyStart(event);
        obj.ramper.TimerFcn = @(~, event)obj.applyStep(event);
        obj.ramper.StopFcn = @(~, event)obj.applyStop(event);
        obj.ramper.ErrorFcn = @(~, event)obj.applyStop(event);
        
        obj.ramper.start();
    end