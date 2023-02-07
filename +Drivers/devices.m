function instruments = devices(varargin)
%Instrument interface function
%   Function searches for available visa devices
%   and creates instrument objectes.
%   
%   Known instruments:
%   A33220A     Agilent 33220A Waveform generator
%   A33250A     Agilent 33250A Waveform generator
%   AMI420      American Magnetics INC 420 Power Supply
%   LSCI331     LakeShore 331 Temperature Controller
%   LSCI340     LakeShore 340 Temperature Controller
%   ILX3724     ILX Lightwave 3724C Laser Diode Controler
%   SR830       Stanford Research 830 Lock-in amplifier
%   SR844       Stanford Research 844 Lock-in amplifier

    % Dictionary of indentification instrument names
    instrumentIDN = struct(...
        'A33220A',  "Agilent Technologies,33220A", ...
        'A33250A',  "Agilent Technologies,33250A", ...
        'AMI420',   "AMERICAN MAGNETICS INC.,MODEL 420", ...
        'LSCI331',  "LSCI,MODEL331S,373212,120407", ...
        'LSCI340',  "LSCI,MODEL340,340403,061407", ...
        'ILX3724',  "ILX Lightwave,3724C,37244074", ...
        'KEPCO',    "KEPCO,ABC-2504,060109-059,V6.8", ...
        'SR830',    "Stanford_Research_Systems,SR830", ...
        'SR844',    "Stanford_Research_Systems,SR844");

    % Instrument names to be printed
    instrumentNames = struct(...
        'A33220A',  "Agilent 33220A Waveform Generator", ...
        'A33250A',  "Agilent 33250A Waveform Generator", ...
        'AMI420',   "American Magnetics 420 Power Supply", ...
        'LSCI331',  "Lakeshore 331 Temperature Controller", ...
        'LSCI340',  "Lakeshore 340 Temperature Controller", ...
        'ILX3724',  "ILX Lightwave 3724C Laser Diode Controler", ...
        'KEPCO',    "KEPCO ABC 25V 4A Programmable Power Supply ", ...
        'SR830',    "Stanford Research 830 Lock-in amplifier", ...
        'SR844',    "Stanford Research 844 Lock-in amplifier");

    % Structure of instrument handles list
    indices = fieldnames(instrumentIDN);
    numIndecies = length(indices);
    instruments = cell2struct(cell(numIndecies, 1), indices);

    % Reset and recconect all instruments
    visaList = visadevlist;
    gpibList = visaList.ResourceName(visaList.Type=="gpib");
    if isempty(gpibList)
        disp("No GPIB instruements found.");
        return
    end
    k = numel(gpibList);
    gpibNums = zeros(k);
    gpibDevs = {};
    
    for i = 1:k
        gpibNums(i) = sscanf(gpibList(i), "GPIB0::%d::INSTR");
        try
            gpibDevs{end+1} = visadev(gpibList(i));
        catch ME
            if strcmp(ME.identifier, "instrument:interface:visa:multipleIdenticalResources")
                disp(strcat(gpibList(i), " is already somewhere in the memory space."));
            end
        end
    end
    

    % Parse instruments by identification string
    fprintf("\nInstruments:\n");
    for i = 1:numel(gpibDevs)
        
        instrument = gpibDevs{i};
        disp(class(instrument));
        gpib = instrument.PrimaryAddress;
        writeline(instrument, "*IDN?")
        name = strtrim(readline(instrument));

        % Find index by IDN name
        indexBool = structfun(@(x) strncmp(x, name, strlength(x)), instrumentIDN);
        if ~any(indexBool)
            fprintf('Unknown instrument <<%s>> was detected\n', name);
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