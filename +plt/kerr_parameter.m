function fig = plot(varargin)
    %Kerr data plot method
    %   Plots content of the logdata file.
    %   Arguments:
    %   - filename {''}
    %   - range {[-inf, inf]}
    %   - dT {1}
    %   - parametername {'parametername'}
    
    % Acquire parameters
    p = inputParser;
    addParameter(p, 'filename', '', @ischar);
    addParameter(p, 'range', [-inf, inf], @isnumeric);
    addParameter(p, 'dT', 1, @isnumeric);
    addParameter(p, 'parametername', 'Parameter', @ischar);
    parse(p, varargin{:});
    parameters = p.Results;
    
    filename = parameters.filename;
    dT = parameters.dT;
    range = parameters.range;
    parametername = parameters.parametername;
    
    % If no filename is given, open file browser
    if isempty(filename) 
        [basefilename, folder] = uigetfile('*.mat', 'Select data file');
        filename = fullfile(folder, basefilename);
        if basefilename == 0
            disp('Please supply logdata structure or path to datafile.');
            return;
        end
    end
    [~, name, ~] = fileparts(filename);
    data = load(filename);
    logdata = data.logdata;
    if isfield(data, 'info')
        if isfield(data.info, 'parametername')
            parametername = data.info.parametername;
        end
    end
    % Configure Figure
    fig = figure('Name', name, ...
        'Units', 'centimeters', ...
        'Position', [0 0 20.5 12.9]);
    set(fig, 'PaperUnits', 'centimeters', 'PaperSize', [11 9]);
    ax = axes(fig);

    % Data
    fieldNames = determine_field_names(logdata);
    H = logdata.parameter;
    factor = 500;
    H = H*factor;
    FirstX = logdata.(fieldNames.firstHarmonicX);
    FirstY = logdata.(fieldNames.firstHarmonicY);
    Second = logdata.(fieldNames.secondHarmonic);
    DC = 1e3*logdata.(fieldNames.dc);
    %K = Sagnatron.calculate_kerr(FirstX, Second);
    K = logdata.(fieldNames.kerr);
    
    fit_result = @(x) -28.720506*x/factor;
    K_background = fit_result(H);
    K = K - K_background;
    
    title(ax, 'Kerr angle');
    plot(ax, H, K, 'LineWidth', 1.5, 'Color', [0, 0, 0], ...
        'DisplayName', sprintf('dT = %.2f K', dT));
    ylabel(ax, '\theta_K (\murad)');
    xlabel(ax, parametername);
    xlabel(ax, "Magnetic field, Oe");
    
    grid(ax, 'on');
    box(ax, 'on');
    xlim(ax, [-750, 750]);
    ylim(ax, [-5,5]);
    
    saveas(fig, sprintf('output/%s.png', name), 'png');
end


function fieldNames = determine_field_names(logdata)
    %Kerr data analysis method
    %   Returns correct logdata structure field names.
    
    possibleFieldNames = struct(...
        'kerr', ["kerr", "kerr2"], ...
        'transportX', ["transport", "transportX"], ...
        'transportY', ["transporty", "transportY"], ...
        'transportR', ["transportr", "transportR"], ...
        'resistanceX', ["resistancex", "resistanceX", "transportx", "transportX"], ...
        'resistanceY', ["resistancey", "resistanceY", "transporty", "transportY"], ...
        'inductanceX', ["incductancex", "inductanceX", "transportx", "transportX"], ...
        'inductanceY', ["inductancey", "inductanceY", "transporty", "transportY"], ...
        'firstHarmonicX', ["firstX", "firstx", "first", "X"], ...
        'firstHarmonicY', ["firstY", "firsty", "Y"], ...
        'secondHarmonic',  ["second", "AUX1"], ...
        'dc',  ["dc", "DC"], ...
        'temperature', ["temp", "temperature", "sampletemperature"], ...
        'temperatureMagnet', ["magnettemperature", "temperatureMagnet"], ...
        'time', ["time", "Time"]);
    
    fields = fieldnames(possibleFieldNames);
    numFields = numel(fields);
    fieldNames = cell2struct(cell(numFields, 1), fields);

    for i = 1:numFields
        field = fields{i};
        for fieldName = possibleFieldNames.(field)
            if isfield(logdata, fieldName)
                fieldNames.(field) = fieldName;
                break;
            end
        end
        if isempty(fieldNames.(field))
            %fprintf("Field <<%s>> is not present.\n", field);
        end
    end
end 