function handle = visa(address)
%Find the instrument given GPIB address.
%   Checks if such instrument is already in memeory,
%   if not, adds such instrument to memory using
%           handle = visa('ni', 'GPIB0::address::INSTR');
%   and checks if it is a valid instrument.

    % Check if instrument with such GPIB is already in memeory
    instrList = instrfind();

    for instr = instrList
        if ~strcmp(instr.Type, 'visa-gpib')
            continue;
        end
        if instr.PrimaryAddress == address
            handle = instr;
            %fprintf('GPIB %d: \tALREADY CONNECTED\n', gpib);
            % Open instrument if it is closed
            if strcmp(handle.Status, 'closed')
                fopen(handle);
            end
            return
        end
    end

    % Add instrument to the memory
    handle = visa('ni', sprintf('GPIB0::%d::INSTR', address));

    % Open instrument if it is closed
    if strcmp(handle.status, 'closed')
        fopen(handle);
    end


    % Check if there is an instrument with such GPIB
    try
        name = char(query(handle, "*IDN?"));
    catch ME
        if strcmp(ME.identifier,'instrument:query:opfailed')
            fprintf("There is no instrument with GPIB %d address.", address)
        else
            rethrow(ME);
        end
        % If there is, close and delete instrument from the memory
        fclose(handle);
        delete(handle);
        handle = [];
        return
    end
    
    handle.Timeout = 1;


    % Assuming there is such an instrument
    name = string(name(1:end-2));
    %fprintf('GPIB %d: \tCONNECTED\n', gpib);

end