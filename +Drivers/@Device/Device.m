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
    %   Use this class define subclasses:
    %   classdef SR830 < Device
    %       ...
    %
    %   Use this class to create generic instruments:
    %   lockin = Drivers.Device(5);
    %   lockin.write("freq 1e3");
    %   lockin.query("outp?1");
    
    properties
        name;
        address;                    %   GPIB address
        id;                         %   Unique name = "name_GPIB"
        handle;                     %   visalib.GPIB or visa handle
        remote = false;             %   If instrument in local/remote mode
        fields;                     %   Fields to read using get method
        parameters;                 %   Parameters to set using set method
    end
    
    methods
        function obj = Device(varargin)
            %Class constructor
            %   See Device.init() method for more information
            
            %Child classes always call superclass constructor.
            %hence it's required to control action of the superclass
            %constructor whe it's called without arguments.
            if ~nargin, return, end
            
            obj = obj.init(varargin{:});
            obj.rename("dev");
            obj.remote = true;
            obj.fields = {};
            obj.parameters = {};
        end
        function out = idn(obj), out = strtrim(obj.query("*IDN?")); end
        % Following two methods are instrument specific
        function set(obj, varargin), obj.parameters = {}; end
        function out = get(obj, varargin), obj.fields = {}; out = []; end
    end
    
    methods (Sealed)
        obj = init(obj, address, handle, varargin)
        write(obj, msg);
        out = read(obj);
        out = query(obj, msg);
        function rename(obj, new_name)
            obj.name = new_name;
            obj.id = sprintf("%s_%02d", obj.name, obj.address);
        end
        function update(obj)
            obj.get(obj.parameters{:});
            obj.get(obj.fields{:});
        end
    end
end

