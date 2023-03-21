function instrument = find_serialport(port, baudrate, terminator)
%Find the serial port given port name
%   Checks if serial port is already in memeory,
%   if not, adds it to the memeory and 
%   checks if it is a valid port.

serialportList = serialportlist("all");
serialportListAvailable = serialportlist("available");

if nargin < 3
    terminator = "CR/LF";
end
if nargin < 2
    baudrate = 921600;
end
if nargin < 1
    port = serialportListAvailable(end);
end

if ~any(strcmp(port, serialportList))
    %fprintf('Serial port %s does not exist.\n', port);
    instrument = [];
    return
end

if ~any(strcmp(port, serialportListAvailable))
    fprintf('Serial port %s is not available.\n', port);
    instrument = [];
    return
end

instrument = serialport(port, baudrate, 'Timeout', 1);
configureTerminator(instrument, terminator)

end