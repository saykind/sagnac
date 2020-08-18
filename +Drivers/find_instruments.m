function instruments = find_instruments(varargin)
%Instrument interface function
%   Function searches for the available instruments and initializes 
%   communication session.
%   
%   Known instruments:
%   A33220A     Agilent 33220A Waveform generator
%   AMI420      American Magnetics INC 420 Power Supply
%   LSCI331     LakeShore 331 Temperature Controller
%   LSCI340     LakeShore 340 Temperature Controller
%   SR844       Stanford Research 844 Lock-in amplifier

% Dictionary of indentification instrument names
instrumentIDN = struct(...
    'A33220A',  "Agilent Technologies,33220A", ...
    'A33250A',  "Agilent Technologies,33250A", ...
    'AMI420',   "AMERICAN MAGNETICS INC.,MODEL 420", ...
    'LSCI331',  "LSCI,MODEL331S,373212,120407", ...
    'LSCI340',  "LSCI,MODEL340,340403,061407", ...
    'SR844',    "Stanford_Research_Systems,SR844");

% Instrument names to be printed
instrumentNames = struct(...
    'A33220A',  "Agilent 33220A Waveform Generator", ...
    'A33250A',  "Agilent 33250A Waveform Generator", ...
    'AMI420',   "American Magnetics 420 Power Supply", ...
    'LSCI331',  "Lakeshore 331 Temperature Controller", ...
    'LSCI340',  "Lakeshore 340 Temperature Controller", ...
    'SR844',    "Stanford Research 844 Lock-in amplifier");

% Structure of instrument handles list
indecies = fieldnames(instrumentIDN);
numIndecies = length(indecies);
instruments = cell2struct(cell(numIndecies, 1), indecies);

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
    disp("No instruements found.");
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
        fprintf('Unknown instrument <<%s>> was detected\n', name);
        continue;
    end 
    index = indecies{indexBool};

    % Save instruemnt
    eval(sprintf("instrum = Drivers.%s(gpib, instrument);", index));
    instruments.(index)(end+1) = instrum;
    fprintf('GPIB %2d:  %s\n', gpib, instrumentNames.(index));
end

% Delete empty lists from instruments structure
idxEmpty = structfun(@isempty, instruments);
instruments = rmfield(instruments, indecies(idxEmpty));

end