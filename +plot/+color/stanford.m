function c = stanford(name)
%STANFORD  Return Stanford color based on name
% Based on the identity guide 
% https://identity.stanford.edu/visual-identity/overview/
% License: https://creativecommons.org/publicdomain/zero/1.0/

    switch name
        % RED (CARDINAL)
        case {'red', 'r', 'cardinal'}
            c = " #8C1515";  % cardinal
        case 'light red'
            c = " #B83A4B";  % light red
        case 'dark red'
            c = " #820000";  % dark red
        %
        % BLUE (LAGUNITA)
        case {'blue', 'lagunita'}
            c = " #007C92";  % lagunita
        case {'light blue', 'light lagunita'}
            c = " #009AB4";  % light blue
        case {'dark blue', 'dark lagunita'}
            c = " #006B81";  % dark blue
        %
        % SKY BLUE
        case {'sky', 'cyan'}
            c = " #00A5DF";  % sky
        case 'light sky'
            c = " #67AFD2";  % light sky
        case 'dark sky'
            c = " #016895";  % dark sky
        % BAY BLUE
        case {'bay'}
            c = " #6FA287";  % bay
        case 'light bay'
            c = " #8AB8A7";  % light bay
        case 'dark bay'
            c = " #417865";  % dark bay
        %
        % GREEN (PALO VERDE)
        case 'palo verde'
            c = " #279989";  % palo verde
        case 'light palo verde'
            c = " #59B3A9";  % light green
        case 'dark palo verde'
            c = " #017E7C";  % dark green
        %
        % PALO ALTO
        case 'palo alto'
            c = " #175E54";  % palo alto
        case 'light palo alto'
            c = " #2D716F";  % light palo alto
        case 'dark palo alto'
            c = " #014240";  % dark palo alto
        %
        % OILVE
        case {'green', 'olive'}
            c = " #8F993E";  % olive
        case 'light olive'
            c = " #A6B168";  % light olive
        case 'dark olive'
            c = " #7A863B";  % dark olive
        %
        % YELLOW (ILLUMINATING)
        case {'yellow', 'illuminating'}
            c = " #FEC51D";  % illuminating
        case {'light yellow', 'light illuminating'}
            c = " #FFE781";  % light illuminating
        case {'dark yellow', 'dark illuminating'}
            c = " #FEC51D";  % dark illuminating
        %
        % ORANGE (POPPY)
        case {'orange', 'poppy'}
            c = " #E98300";  % poppy
        case {'light orange', 'light poppy'}
            c = " #F9A44A";  % light poppy
        case {'dark orange', 'dark poppy'}
            c = " #D1660F";  % dark poppy
        %
        % PURPLE (PLUM)
        case {'purple', 'plum'}
            c = " #620059";  % plum
        case {'light purple', 'light plum'}
            c = " #734675";  % light plum
        case {'dark purple', 'dark plum'}
            c = " #350D36";  % dark plum
        %
        % STONE
        case 'stone'
            c = " #7F7776";  % stone
        case 'light stone'
            c = " #D4D1D1";  % light stone
        case 'dark stone'
            c = " #544948";  % dark stone
        %
        % FOG
        case 'fog'
            c = " #DAD7CB";  % fog
        case 'light fog'
            c = " #F4F4F4";  % light fog
        case 'dark fog'
            c = " #B6B1A9";  % dark fog
        %
        % BLACK and WHITE
        case {'black', 'k'}
            c = " #2E2D29";  % black
        case {'gray', 'grey'}
            c = " #53565A";  % cool gray
        case {'white', 'w'}
            c = " #FFFFFF";  % white
        %
        % DEFAULT
        otherwise
            util.msg('Unknown color: %s', str);
            c = " #8C1515";  % cardinal
    end

    c = strtrim(c);

    end