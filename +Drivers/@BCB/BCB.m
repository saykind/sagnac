classdef BCB < Drivers.Port
%BCB class is used to communicate with Bias Control Board BCB-4
%   Board is supplied by optilab.com
%   https://www.optilab.com/products/modulator-bias-control-board-four-bias-mode
%
%   Example
%   bcb = Drivers.BCB();
%   mode = bcb.mode;
%   bcb.voltage = 10;

    properties
        add;                %   Address of the board
        mode;               %   Mode of the board
                            %       1: Q+
                            %       2: Q-
                            %       3: MAX
                            %       4: MIN
                            %       5: Manual
        voltage;            %   Voltage of the board, Volts
        vpi;                %   Half-wave voltage, Volts
        optical_power;      %   Optical power, uW
    end

    properties (Access = protected)
        %   BCB specific properties
        voltage_max = 10.98;                % Volts
        voltage_min = -10.97;               % Volts
        dither_max = 488;                   % mVpp
        dither_min = 0;                     % mVpp
        optical_power_coeff = 0.230         % dimensionless
        voltage_coeff = 1.34e-3;            % dimensionless

        %   BCB test items (for reference)
        input_power = 16.22;                % dBm
        max_output_power = 11.66;           % dBm
        min_output_power = -21.66;          % dBm
        q_plus_output_power = 8.65;         % dBm
        q_minus_output_power = 8.65;        % dBm
        extinction_ratio = 33.31;           % dB

        % IMP-1550-10-PM specific properties
        vpi_dc = 6.1;                       % Volts (DC port)
        vpi_rf = 6.3;                       % Volts (RF port) @ 1 GHz

        % Following values drift with time
        v_min = 2.87;                       % Voltage bias minimizing optical power, Volts
        v_max = -5.56;                      % Voltage bias maximizing oprical power, Volts

    end

    methods
        function obj = BCB(port, options)
            %BCB construct class
            arguments
                port = 8;
                options.add (1,1) double = 1;
                options.baudrate (1,1) double = 9600;
                options.terminator (1,1) string = "CR/LF";
            end

            if ~nargin, return; end
            
            obj = obj.init(port, 'baudrate', options.baudrate, 'terminator', options.terminator);
            obj.name = "BCB";
            obj.id = obj.name + "_" + obj.address;
            obj.add = options.add;

            obj.fields = {'optical_power'};
            fieldUnits = {'uW'};
            obj.parameters = {'mode',   'voltage',  'vpi'};
            parameterUnits = {'',       'V',        'V'};
            units = [[obj.fields, obj.parameters]; [fieldUnits, parameterUnits]];
            obj.units = struct(units{:});

            % Check parameter values
            if obj.vpi ~= 0
                warning("Vpi is not zero. Feedback loop won't work properly.");
            end
        end

        function reset(obj)
            %RESET Reset the board
            obj.writef("RESET%d", obj.add);
        end

        % Getters
        function mode = get.mode(obj), mode = obj.get('mode'); end
        function voltage = get.voltage(obj), voltage = obj.get('voltage'); end
        function vpi = get.vpi(obj), vpi = obj.get('vpi'); end
        function optical_power = get.optical_power(obj), optical_power = obj.get('optical_power'); end
    
        % Setters
        function set.mode(obj, mode), obj.set('mode', mode); end
        function set.voltage(obj, voltage), obj.set('voltage', voltage); end
        function set.vpi(obj, vpi), obj.set('vpi', vpi); end
    end
end
