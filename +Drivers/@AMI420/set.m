function obj = set(obj, varargin)
    %Parameter set method
    %
    %   Usage example:
    %   obj.set('pswitch', 1);

    % Acquire parameters
    p = inputParser;
    
    addParameter(p, 'programmedField', NaN, @isnumeric);
    addParameter(p, 'programmedCurrent', NaN, @isnumeric);
    addParameter(p, 'fieldUnits', [], @(x) strcmp(x, 'T') || strcmp(x, 'kG'));
    addParameter(p, 'coilConstant', NaN, @isnumeric);
    addParameter(p, 'pswitch', NaN, @(x) x==0 || x==1);
    addParameter(p, 'rampRate', NaN, @isnumeric);
    
    parse(p, varargin{:});
    parameters = p.Results;
    
    % Set values
    if ~isnan(parameters.programmedField)
        f = parameters.programmedField;
        obj.programmedField = f;
        fprintf(obj.handle, "configure:field:program %f", f);
    end
    if ~isnan(parameters.programmedCurrent)
        c = parameters.programmedField;
        obj.programmedCurrent = c;
        fprintf(obj.handle, "configure:current:program %f", c);
    end
    if ~isempty(parameters.fieldUnits)
        switch parameters.fieldUnits
            case 'T'
                obj.fieldUnits = 'T';
                fprintf(obj.handle, "configure:field:units 1");
            case 'kG'
                obj.fieldUnits = 'kG';
                fprintf(obj.handle, "configure:field:units 0");
        end
    end
    if ~isnan(parameters.coilConstant)
        cc = parameters.coilConstant;
        if cc <= 0
            error('Coil Constant has to be positive.');
        end
        obj.coilConstant = cc;
        fprintf(obj.handle, "configure:coilconstant %f", cc);
    end
    if ~isnan(parameters.pswitch)
        obj.pswitchState = parameters.pswitch;
        fprintf(obj.handle, "pswitch %d", parameters.pswitch);
    end
    if ~isnan(parameters.rampRate)
        obj.rampRateField = parameters.rampRate;
        fprintf(obj.handle, "configure:ramp:rate:field %f", parameters.rampRate);
    end
    
    
    
    
        
    
end