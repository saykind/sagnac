function title = make_title(key)
%Initialization function.
%   Numeric key selects pre-defined experiment setups:
%       104 'h' -  Hall effect measurement

switch key
    case {84, 'T', 'Temperature'}
        title = "Temperature measurement";
    case {104, 'h', 'hall'}
        title = "Hall effect measurement";
    case 'u'
        title = "User defined experiment";
    otherwise
        fprintf("[Sweeper.make_title] Unkown key.");
end