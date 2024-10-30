function title = title(seed)
%Initialization function.
%   Numeric key selects pre-defined experiment setups:
%       104     h   Hall effect measurement

key = make.key(seed);

switch key
    case 122        %z: HF2LI lockin data only
        title = "HF2LI lockin";
    case 5978       %z1: HF2LI lockin single demodulator data only
        title = "HF2LI lockin";
    case 1771440    %zxy: Kerr XY scan
        title = "HF2LI and XY scan";
    case 14640      %zx: Kerr x scan
        title = "HF2LI and X scan";
    case 13054      %zk: Kerr effect + temperature
        title = "Kerr Effect";
    case 14762      %zy: Hysteresis Kerr
        title = "Hysteresis Kerr";
    case 1207068    %zfa: Frequency and amplitude sweep
        title = "Frequency and amplitude sweep";
    case 11834      %za: Amplitude sweep
        title = "Amplitude sweep";
    case 12444      %zf: Frequency sweep
        title = "Frequency sweep";
    case 1313574    %zao: Amplitude offset set
        title = "Amplitude offset set";
    case 1488156    %zkr: Kerr + temperature + resistance
        title = "Kerr and resistance";
    case 13110      %sr: Strain + resistance (no bridge)
        title = "Strain and resistance";
    case 950796     %bcb: BCB voltage and optical power
        title = "Bias Control Board";
    case 1076922    %bco: BCB offset voltage sweep
        title = "BCB offset voltage sweep";
    case 1327116    %zbo" BCB offset voltage sweep
        title = "BCB offset voltage sweep";
    case 707600     %z2t: Zurich 2 demods + temperature
        title = "HF2LI lockin: RMCD";
    case 1388970    %zcs: Zurich + Keithley current sweep
        title = "Current sweep";
    case 1374940    %zsb: Zurich side band ac kerr
        title = "Side band MOKE";
    case 1546980    %rsv: Resistance vs AUXV1 (strain voltage)
        title = "Resistance vs AUXV1";
    case 12810      %zi: Laser current sweep
        title = "Laser current sweep";
    case 615600     %r2l: resitance 2 lockins
        title = "Transport";


    case 11960  %hs: Hall sensor
        title = "Hall sensor";
    case 84     %T: Temperature only
        title = "Temperature measurement";
    case 108    %l: Lockin measurement
        title = "Lockin measurement";
    case 114     %r: time vs Resistance
        title = "Resistance measurement";
    case 68     %D: Diode temperature
        title = "Diode Temperature measurement";
    case 104    %h: Hall effect
        title = "Hall effect measurement";
    case 11948  %tg: Two transport lockins & gate voltage controller
        title = "Gate voltage sweep";
    case 11832  %tf: Frequency sweep with transport lockin
        title = "Transport freq sweep";
    case 116    %t: two lockins
        title = "Transport";
    case 11682  %cv: Capacitance vs voltage
        title = "Strain cell capacitance";
    case 11286  %cr: Capacitance, resistance vs voltage
        title = "Strain cell capacitance";

    case 112    %p: optical power using Newport 1830-C
        title = "Optical power measurement";
    case 100    %d: laser current sweep DC power measurement
        title = "DC voltage, Diode current sweep";
    case 477128 %LIV:  Laser IV characteristic
        title = "Laser IV";
    case 11600  %td: dc voltage (time only)
        title = "time vs dc voltage";
    case 9900   %dc: dc voltage (Large number)
        title = "time vs dc voltage";

    case 107    %k: kerr effect
        title = "Kerr Effect";
    case 12412  %tk: Kerr vs time
        title = "Kerr vs Time (time)";
    case 1290848%kth: kerr, transport, hall
        title = "Kerr and Transport";
    case 1278436%ktg: Kerr, transport, gate
        title = "Kerr vs Gate";
    case 11128  %hk: Kerr vs field, hysteresis test
        title = "Kerr vs Field";
    case 121    %y: Kerr vs field, hysteresis test
        title = "Hysteresis Kerr";
    case 1346488%khy: Kerr vs field, hysteresis sweep
        title = "Hysteresis Kerr";
    case 1228788    %ktc: kerr, transport, capacitance
        title = "Kerr and strain";
    case 10593  %kc: kerr vs strain (capacitance)
        title = "Kerr vs strain";
        
    case 105    %i: laser current sweep
        title = "Laser intensity";
    case 102    %f: frequency sweep
        title = "Modulation frequency sweep";
    case 97     %a: amplitude sweep
        title = "Modulation amplitude sweep";
    case 9894   %fa: frequency and amplitude sweep
        title = "Modulation frequency and amplituide sweep";
    case 9603   %ca: laser current and modulation amplitude sweep
        title = "Laser current and modulation amplitude sweep";
    case 14520  %xy: Kerr 2D scan
        title = "Kerr 2D scan";
    case 120    %x: Kerr 1D scan
        title = "Kerr 1D scan";

    case 119    %w: wavelength
        title = "Emission Spectrum measurement";

    case 117    %u: user defined
        title = "User defined experiment";

    otherwise
        title = "title";
        fprintf("[make.title] Unkown key.\n");
end