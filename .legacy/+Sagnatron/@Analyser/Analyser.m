classdef (Sealed = true) Analyser < handle
    %Kerr agnle data analysis class
    %   Release June 25, 2020 (v1.0)
    %
    %   This class was created for anlysis of Sagnac interferometer data in
    %   Kapitulnik research group.
    %   Written by David Saykin (saykind@itp.ac.ru)
    %
    %   Matlab 2019b or higher is required.
    %   The following packages are used:
    %   - Statistics and Machine Learning Toolbox
    %   - Curve Fitting Toolbox
    %   - Instrument Control Toolbox
    %
    %
    %   Usage example:
    %   data = Sagnatron.Analyser();
    %   data.load();
    %   data.kerr();
    
    properties
        path;                       %   Path to data.mat file 
        filename;                   %   Last part of the path
        data;                       %   Main data structure  
        comments;                   %   Comments from data.mat file
        fieldNames;                 %   Names of the logdata structure fields
        
        tempFigure;                 %   Handle to the last used figure
        timeFigure;                 %   Handle to the last used figure
        kerrAxes;                   %   Handle to the last used axes
        
        phase = 0;                  %   Phase between first and second harmonic
        offset = 0;                 %   Constant kerr angle shift
        offsetRange = [-inf, inf];  %   Estimate for non-ferromagnetic interval
        autoPhase = true;           %   Specify if phase should be computed
        
        showOffset = true;          %   Specify if offset area should be shown
        showLegend = false;         %   Specify if legend should be added
        showRefline = true;         %   Specify if x-axis should be bold
        verbose = false;            %   Specify if you want program talk back
        
        tempRange = [-inf, inf];    %   Plot range of temperature data
        timeRange = [-inf, inf];    %   Plot range of time data
        fieldRange = [-inf, inf];   %   Plot range of magnetic field
        
        tempBin = .10;              %   Temperatue coarse graining scale 
                                    %   (default: .1 K)
        timeBin = .05;              %   Time coarse graining scale 
                                    %   (default: 3 min = .05 hours)
        fieldBin = 10;              %   Magnetic field coarse graining scale
                                    %   (default: 10 Gauss = .001 Tesla)
    end
    
    methods
        function obj = Analyser(varargin)
            %Sagnatron Construct an instance of this class
            %   If present, the only argument shoud be either a path to 
            %   data.mat file or a logdata structure.
            if nargin
                obj = obj.load(varargin{:});
            end
        end
        obj = load(obj, arg);
        obj = save(obj, path);
        fig = plot(obj);
        fig = plott(obj);
        ax  = kerr(obj);
        [phase, offset] = calc(obj);
    end
    
    methods(Static)
        function fig = plot_time(logdata, varargin)
            %Raw data representation method
            %   Plots Kerr angle, first and second harmonics amplitudes and
            %   temperature as a function of time
            fig = Sagnatron.plot_time(logdata, varargin{1:nargin-1});
        end
        function fig = plot_temperature(logdata, varargin)
            %Raw data representation method
            %   Plots Kerr angle, first and second harmonics amplitudes as a function of temperature
            fig = Sagnatron.plot_temperature(logdata, varargin{1:nargin-1});
        end
        function fig = plot_kerr(logdata, varargin)
            %Kerr data analysis and plotting method
            %   Finds optimal phase shift and plots corresponding Kerr angle as a function of temperature
            fig = plot_kerr(logdata, varargin{1:nargin-1});
        end
    end
    
end

