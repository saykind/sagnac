function instrument = find_instrument(gpib)
%Find the instrument given GPIB
%   Check if such instrument is already in memeory,
%   if not adds such instrument to the memeory and check if it 
%   is a valid instrument.

% Check if instrument with such GPIB is already in memeory
instrList = instrfind();

for instr = instrList
    if instr.PrimaryAddress == gpib
        instrument = instr;
        fprintf('GPIB %d: \tALREADY CONNECTED\n', gpib);
        % Open instrument if it is closed
        if strcmp(instrument.status, 'closed')
            fopen(instrument);
        end
        return
    end
end

% Add instrument to the memory
instrument = visa('ni', sprintf('GPIB0::%d::INSTR', gpib));

% Open instrument if it is closed
if strcmp(instrument.status, 'closed')
    fopen(instrument);
end
    
% Check if there is an instrument with such GPIB
try
    name = char(query(instrument, "*IDN?"));
catch ME
    if strcmp(ME.identifier,'instrument:query:opfailed')
        fprintf("There is no instrument with GPIB %d address.", gpib)
    else
        rethrow(ME);
    end
    % If there is, close and delete instrument from the memory
    fclose(instrument);
    delete(instrument);
    instrument = [];
    return
end

% Assuming there is such an instrument
name = string(name(1:end-2));
fprintf('GPIB %d: \tCONNECTED\n', gpib);

end