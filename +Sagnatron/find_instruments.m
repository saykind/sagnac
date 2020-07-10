function instruments = find_instruments()
%Instrument interface function
%   Function searches for the available instruments and initializes 
%   communication session.
americanMagneticsName = "AMERICAN MAGNETICS INC.,MODEL 420,3.";
lakeShoreName = "LSCI,MODEL340,340403,061407";

instrreset();
commands = instrhwinfo('visa', 'ni').ObjectConstructorName;

for i = 1:length(commands)
    
    if strncmp(commands{i}, "visa('ni', 'GPIB", 16)
        disp(commands{i})
        eval(commands{i});
    end
end

instruments = containers.Map;

instrument_list = instrfind();

if isempty(instrument_list)
    fprintf("No instruemtns found.");
    return
end

for instrument = instrument_list
    if strcmp(instrument.status, 'closed')
        fopen(instrument);
    end
    name = char(query(instrument, "*IDN?"));
    name = string(name(1:end-2));
    switch name
        case americanMagneticsName
            instruments('Magnet') = instrument;
            fprintf('CONNECTED: American Magnetics 420 Power Supply\n');
        case lakeShoreName
            instruments('Temperatue') = instrument;
            fprintf('CONNECTED: Lakeshore 340 Temperature Controller\n');
        otherwise
            fprintf('Unknown instrument <<%s>> was detected\n', name);
    end
end
end