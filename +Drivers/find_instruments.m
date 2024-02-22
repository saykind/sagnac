function instruments = find_instruments(varargin)
%Instrument interface function
%   Function searches for the available instruments and initializes 
%   communication session.
%
%   
%   Known instruments:
%   A33220A         Agilent 33220A Waveform generator
%   A33250A         Agilent 33250A Waveform generator
%   AMI420          American Magnetics INC 420 Power Supply
%   LSCI331         LakeShore 331 Temperature Controller
%   LSCI340         LakeShore 340 Temperature Controller
%   ILX3724         ILX Lightwave 3724C Laser Diode Controler
%   Keithley2182A   Keithley 2182A Nanovoltmeter
%   KEPCO           Kepco ABC-2504 Power Supply
%   SR830           Stanford Research 830 Lock-in amplifier
%   SR844           Stanford Research 844 Lock-in amplifier

    % Dictionary of indentification instrument names
    instrumentIDN = struct(...
        'A33220A',          "Agilent Technologies,33220A", ...
        'A33250A',          "Agilent Technologies,33250A", ...
        'AMI420',           "AMERICAN MAGNETICS INC.,MODEL 420", ...
        'LSCI331',          "LSCI,MODEL331S", ...
        'LSCI340',          "LSCI,MODEL340", ...
        'ILX3724',          "ILX Lightwave,3724C,37244074", ...
        'Keithley2182A',    "KEITHLEY INSTRUMENTS INC.,MODEL 2182A", ...
        'KEPCO',            "KEPCO,ABC-2504", ...
        'SR830',            "Stanford_Research_Systems,SR830", ...
        'SR844',            "Stanford_Research_Systems,SR844");

    % Instrument names to be printed
    instrumentNames = struct(...
        'A33220A',          "Agilent 33220A Waveform Generator", ...
        'A33250A',          "Agilent 33250A Waveform Generator", ...
        'AMI420',           "American Magnetics 420 Power Supply", ...
        'LSCI331',          "Lakeshore 331 Temperature Controller", ...
        'LSCI340',          "Lakeshore 340 Temperature Controller", ...
        'ILX3724',          "ILX Lightwave 3724C Laser Diode Controler", ...
        'Keithley2182A',    "Keithley 2182A Nanovoltmeter", ...
        'KEPCO',            "Kepco ABC-2504 Power Supply", ...
        'SR830',            "Stanford Research 830 Lock-in amplifier", ...
        'SR844',            "Stanford Research 844 Lock-in amplifier");

    % Structure of instrument handles list
    indices = fieldnames(instrumentIDN);
    numIndecies = length(indices);
    instruments = cell2struct(cell(numIndecies, 1), indices);

    % Reset and recconect all instruments
    if nargin && (varargin{1} == 0)
        try
            disp(" > instrreset();");
            instrreset();
        catch ME
            if (strcmp(ME.identifier,'instrument:fdelete:opfailed'))
                disp(" > instrreset();");
                instrreset();
            end
        end

        info = instrhwinfo('visa', 'ni');
        commands = info.ObjectConstructorName;

        for i = 1:length(commands)
            if strncmp(commands{i}, "visa('ni', 'GPIB", 16)
                disp(" > " + commands{i});
                eval(commands{i});
            end
        end
    end

    % Load intrument handles to memory
    instrList = instrfind();

    if isempty(instrList)
        disp("No instruments found.");
        return
    end

    % Parse instruments by identification string
    fprintf("\nInstruments:\n");
    for instrument = instrList
        if strcmp(instrument.status, 'closed')
            fopen(instrument);
        end

        gpib = instrument.PrimaryAddress;
        name = strtrim(query(instrument, "*IDN?"));

        % Find index by IDN name
        indexBool = structfun(@(x) strncmp(x, name, strlength(x)), instrumentIDN);
        if ~any(indexBool)
            fprintf('GPIB %2d:  <<%s>> was detected\n', gpib, name);
            continue;
        end 
        index = indices{indexBool};

        % Save instruemnt
        eval(sprintf("instrum = Drivers.%s(gpib, instrument);", index));
        instruments.(index)(end+1) = instrum;
        fprintf('GPIB %2d:  %s\n', gpib, instrumentNames.(index));
    end

    % Delete empty lists from instruments structure
    idxEmpty = structfun(@isempty, instruments);
    instruments = rmfield(instruments, indices(idxEmpty));

end