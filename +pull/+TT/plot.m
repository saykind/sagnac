function graphics = plot(graphics, logdata)
%Graphics plotting function.

    ax = graphics.axes;
    for a = ax'
        yyaxis(a, 'left'); cla(a);
        yyaxis(a, 'right'); cla(a);
    end

    d = datetime(logdata.watch.datetime);   % Time, datetime
    t = d - d(1);                           % Time, seconds
    t = minutes(t);                         % Time, minutes

    TA = logdata.tempcont.A;        % LSCI 331 Temperature A, K
    TB = logdata.tempcont.B;        % LSCI 331 Temperature B, K

    tempA = logdata.temp.A;         % LSCI 340 Temperature A, K
    tempB = logdata.temp.B;         % LSCI 340 Temperature B, K

    yyaxis(ax(1), 'left');
    plot(ax(1), t, TA, 'Color', 'r');
    yyaxis(ax(1), 'right');
    plot(ax(1), t, TB, 'Color', 'b');

    yyaxis(ax(2), 'left');
    plot(ax(2), d, tempA, 'Color', 'r');
    yyaxis(ax(2), 'right');
    plot(ax(2), d, tempB, 'Color', 'b');
    
end