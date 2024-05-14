classdef Port < handle
    %Superclass for serial port communication.
    %   It contains basic methods write, read, query,
    %   which other instrument classes inherit.
    %
    %
    %   Use this class to define subclasses:
    %   classdef Agilis < Drivers.Device
    %       ...
    %
    %   Use this class to create generic instruments:
    %   bcb = Drivers.Port(5);
    %   bcb.query("read1v");
    %   bcb.writef("set%dv:%d", 1, 8000);
    
    properties
        name;                       %   Instrument specific name
        address;                    %   numeric COM address
        port;                       %   string COM port
        interface;                  %   Interface type, e.g. "serial"
        id;                         %   Unique name, e.g. "name_address"
        baudrate;                   %   Baudrate of the port
        terminator;                 %   Terminator of the port
        buffer;                     %   Number of bytes in buffer
        handle;                     %   serialport handle
        fields;                     %   Fields to read using get method
        parameters;                 %   Parameters to set using set method
        units;                      %   Physical units of fields and parameters
        verbose;                    %   Print debug information
    end

    properties (Access = protected)
        %   Instrument specific properties
    end
    
    methods
        function obj = Port(varargin)
            % Constructor
            % See Port.init() method for more information
            obj.name = "port";
            obj.address = NaN;
            obj.port = "";
            obj.interface = "serial";
            obj.id = obj.name + "_" + obj.port;
            obj.baudrate = 9600;
            obj.terminator = "CR/LF";
            obj.buffer = 0;
            obj.id = "";
            obj.handle = [];
            obj.fields = {};
            obj.parameters = {};
            obj.units = {};
            obj.verbose = false;
            
            % Child classes always call superclass constructor.
            % Hence it's required to control action of the superclass
            % constructor when it's called without arguments.
            if ~nargin, return, end
            
            obj = obj.init(varargin{:});
        end
        obj = init(obj, address, handle, varargin);
        delete(obj);    % it's important that desctructor doesn't return object
        % Following methods are instrument specific
        function set(obj, varargin), obj.parameters = {}; end
        function varargout = get(obj, varargin), obj.fields = {}; varargout = varargin; end
    end
    
    methods (Sealed)
        write(obj, msg);
        writef(obj, msg, varargin);
        out = read(obj);
        out = query(obj, msg);
        out = queryf(obj, msg, varargin);
    end
end

