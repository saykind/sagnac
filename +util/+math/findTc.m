function [Tc1, Tc2] = findTc(T,R, options)
%FINDTC Find the critical temperature of a superconductor from
%the resistance vs temperature data.

    arguments
        T double {mustBeNumeric}
        R double {mustBeNumeric}
        options.Tc_max double {mustBeNumeric} = 30;  % Sample is normal above this temperature
        options.Tc_guess double {mustBeNumeric} = NaN;  % Initial guess for Tc
        options.Tc_min double {mustBeNumeric} = 2;  % Sample is superconducting below this temperature
    end 

    % Check that data is sorted
    if any(diff(T) < 0)
        error('Temperature data must be sorted in ascending order.');
    end

    %% Maximum derivative method
    %  Find the index of the inflection point
    [~, idx_max_df] = max(diff(R));
    Tc1 = T(idx_max_df);

    %% Half-normal method
    % Fit a line to the linear region
    idx = T > options.Tc_max & T < 2*options.Tc_max;
    p = polyfit(T(idx), R(idx), 1);
    R_normal = polyval(p, T);
    Tc2 = T(end+1-find(flip((R_normal/2>R)), 1));
end


