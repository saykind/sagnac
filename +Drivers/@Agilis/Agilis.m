classdef (Sealed = true) Agilis < handle
    %Driver for KEPCO Lock-in amplifier
    %   Release January 23, 2023 (v0.1)
    %
    %   This class was created in Kapitulnik research group.
    %   Written by David Saykin (saykind@itp.ac.ru)
    %
    %   Matlab 2018b or higher is required.
    %   The following packages are used:
    %   - Instrument Control Toolbox
    %
    %
    %   Usage example:
    %   stageX = Drivers.Agilis();
    %   stageX.move(.5);
    %   positionX = stageX.get('position');
    %   [positionX, targetX] = stageX.get('position', 'target');
    
    properties
        name = 'Agilis';
        port;                       %   Serial port name
        interface = "serial";       %   Drivers.(interface)(address)
        address = 0;                %   Drivers.(interface)(address)
        idn;                        %   Unique name
        id;                         %   Instrument identifier 
        serial;                     %   Instrument serial number
        handle = [];                %   Serialport handle
        state;                      %   Moving/Ready/Not referenced/etc...
        state_hex;
        state_num;
        error;                      %   Last command error
        error_str;
        buffer;                     %   Number of bytes in buffer
        
        unit;                       %   Encoder increment value
        factor;                     %   Interpolation factor
        deadband;                   %   Area, around a set position, 
                                    %       in which the controller will not 
                                    %       try to make any more corrections.
        hometype;                   %   Home search type
                                    %       1: current position is home
                                    %       4: negative end is home
        neglim;                     %   Negative motion limit
        poslim;                     %   Positive motion limit
        
        wait = 1;                   %   Whether probram sleeps during motion 
        fields;                     %   Fields to read
        position;                   %   Current position
    end
    
    methods
        function obj = Agilis(port, handle, varargin)
            %Agilent33220A construct class
            %   If more than one argument is present, 
            %   the rest arguments are passed to set method
            if ~nargin
                return
            end
            
            if nargin == 1
                if isnumeric(port)
                    obj.address = port;
                    port = ['COM', int2str(port)];
                end
                handle = Drivers.serial(port);
                if isempty(handle)
                    error("Serial port is not available.");
                end
            else
                if ~isa(handle, 'internal.Serialport')
                    error("Agilis constructor accepts Serialport handles only.");
                end
            end
            
            obj.port = port;
            obj.handle = handle;
            obj.idn = sprintf("%s_%s", obj.name, obj.port);
            obj.get('id');
            
            % Setting up home position
            obj.reset();
            %obj.set('hometype', 4);
            obj.set('hometype', 1);
            obj.ready();
            
            % Test read
            obj.fields = {'id', 'state',...
                'error', 'factor', 'unit',...
                'deadband', 'home', 'position',...
                'neglim', 'poslim'};
            obj.get(obj.fields{:});
            
            % Test move
            %obj.set('position', 13);
            obj.ps();
            
            if nargin > 2
                obj = obj.set(varargin{2:end});
            end
        end
        
        obj = write(obj, cmd);
        out = read(obj);
        out = query(obj, cmd);
        
        out = configure(obj);
        state = ready(obj)

        out = move(obj, shift);
        out = set(obj, varargin);
        varargout = get(obj, varargin);
        
        function state = reset(obj)
            obj.write("1RS");
            java.lang.Thread.sleep(500);
            state = obj.st();
        end
        
        function state = disable(obj)
            state = obj.st();
            if strcmp(state, "READY")
                obj.write("1MM0");
                state = obj.st();
                return
            end
            if strcmp(state, "DISABLE")
                obj.write("1MM1");
                state = obj.st();
                return
            end
            warning("DISABLE state can only be entered from READY state.")
        end
        
        function clear(obj)
            obj.handle = [];
        end
        
        function out = ps(obj)
            out = obj.get('position');
        end
        
        function out = st(obj)
            out = obj.get('state');
        end
        
        function out = update(obj)
            obj.get(obj.fields{:});
            out = obj.get('error');
        end
    end
end





