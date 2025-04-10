function [strain, d, d0] = from_capacitance(C, T, options)
%Extract strain (in percent) from capacitance.

arguments
    C (:,1) double {mustBeReal, mustBeFinite}                       % Capacitance in pF
    T (:,1) double {mustBeReal, mustBeFinite} = 290                 % Temperature in K
    options.Cp (1,1) double {mustBeReal, mustBeFinite} = 0.00043    % Parasitic capacitance in pF
    options.alpha (1,1) double {mustBeReal, mustBeFinite} = 60.162  % Coefficient in um*pF
    options.d0 (1,1) double {mustBeReal} = NaN                      % Initial distance in um
    options.d0_sample (1,1) double {mustBeReal} = NaN               % Initial distance in um for the sample
end

    Cp = options.Cp;
    C = C - Cp;
    alpha = options.alpha;

    if isscalar(T)
        T = T*ones(size(C));
    end

    if ~isnan(options.d0)
        d0 = options.d0*ones(size(C));
    else
        a0 = 56.55;
        a1 = -0.00217;
        a2 = -9.02e-5;
        a3 = 3.1e-7;
        a4 = -5.6e-10;
        d0 = a0 + a1*T + a2*T.^2 + a3*T.^3 + a4*T.^4;
    end

    d = alpha./C - d0;      % Distance in um
    if ~isnan(options.d0_sample)
        d0 = options.d0_sample;
        strain = d/d0*100;
    else
        strain = d./d0*100;

end