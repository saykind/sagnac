classdef Device < handle
    %Superclass for all instruments. 
    %   It contains basic methods write, read, query, idn, 
    %   which other instrument classes inherit.
    %
    %   Release February, 2023
    %   This class was created in Kapitulnik research group.
    %   Written by David Saykin (saykind@itp.ac.ru)
    %
    %   Matlab 2018b or higher is required.
    %   The following packages are used:
    %   - Instrument Control Toolbox
    %
    %
    %   Use this class to define subclasses:
    %   classdef SR830 < Drivers.Device
    %       ...
    %
    %   Use this class to create generic instruments:
    %   lockin = Drivers.Device(5);
    %   lockin.write("freq 1e3");
    %   lockin.query("outp?1");
    
    properties
        name;                       %   Instrument specific name
        address;                    %   GPIB address
        interface;                  %   Drivers.(interface)(address)
                                    %   is used to find instrument handle
                                    %   Allowed options:
                                    %    - gpib
                                    %    - visa
                                    %    - visadev
        id;                         %   Unique name = "name_address"
        handle;                     %   visalib.GPIB or visa or gpib handle
        fields;                     %   Fields to read using get method
        parameters;                 %   Parameters to set using set method
        units;                      %   Physical units of fields and parameters
        verbose;                    %   Print debug information
    end
    
    methods
        function obj = Device(varargin)
            %Constructor. See Device.init() method for more information
            obj.address = NaN;
            obj.interface = 'visa';
            obj.id = "";
            obj.handle = [];
            obj.fields = {};
            obj.parameters = {};
            obj.units = {};
            obj.verbose = false;
            
            %Child classes always call superclass constructor.
            %Hence it's required to control action of the superclass
            %constructor when it's called without arguments.
            if ~nargin, return, end
            
            obj = obj.init(varargin{:});
            obj.rename("dev");
        end
        obj = init(obj, address, handle, varargin)
        function out = idn(obj), out = strtrim(obj.query("*IDN?")); end
        % Following methods are instrument specific
        function set(obj, varargin), obj.parameters = {}; end
        function out = get(obj, varargin), obj.fields = {}; out = []; end
        function local(obj), obj.id; end % placeholder for local mode function
        function remote(obj), obj.id; end % placeholder for remote mode function
    end
    
    methods (Sealed)
        write(obj, msg);
        writef(obj, msg, varargin);
        out = read(obj);
        out = query(obj, msg);
        out = queryf(obj, msg, varargin);
        function rename(obj, new_name)
        %Change obj.name and obj.id
            obj.name = new_name;
            obj.id = sprintf("%s_%02d", obj.name, obj.address);
        end
        function obj = update(obj)
        %Read fields and parameters
            obj.get(obj.parameters{:});
            obj.get(obj.fields{:});
        end
    end
end

