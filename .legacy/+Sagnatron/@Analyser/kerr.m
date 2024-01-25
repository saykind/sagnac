function ax = kerr(obj)
    %Kerr data analysis and plotting method
    %   Plots Kerr angle, first and second harmonics amplitudes as
    %   a function of temperature
    if isempty(obj.data)
        obj.load();
    end

    [ax, phase] = Sagnatron.plot_kerr(obj.data, ...
        obj.fieldNames, ...
        'axes', obj.kerrAxes, ...
        'bin', obj.tempBin, ...
        'phase', obj.phase, ...
        'range', obj.tempRange, ...
        'offsetRange', obj.offsetRange, ...
        'autoPhase', obj.autoPhase, ...
        'showOffset', obj.showOffset, ...
        'showLegend', obj.showLegend, ...
        'showRefline', obj.showRefline, ...
        'verbose', obj.verbose);
    obj.kerrAxes = ax;
    obj.phase = phase;
end 