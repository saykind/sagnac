function graphics = plot(graphics, logdata)
%Graphics plotting function.

    [ax0f, ax1f, ax2f] = util.unpack(graphics.axes);
    for ax = util.unpack(graphics.axes)
        yyaxis(ax, 'left'); cla(ax);
        yyaxis(ax, 'right'); cla(ax);
    end

    f = 1e-6*logdata.lockin.oscillator_frequency(:,1);
    aux1 = logdata.lockin.auxin0(:,1);
    aux2 = logdata.lockin.auxin1(:,1);
    x1 = logdata.lockin.x(:,1)./aux1;
    y1 = logdata.lockin.y(:,1)./aux1;
    x2 = logdata.lockin.x(:,2)./aux1;
    y2 = logdata.lockin.y(:,2)./aux1;
    r1 = sqrt(x1.^2 + y1.^2);
    r2 = sqrt(x2.^2 + y2.^2);

    yyaxis(ax0f, 'right');
    %plot(ax0f, angle, aux2, 'b-');
    yyaxis(ax0f, 'left');
    plot(ax0f, f, aux1, 'r-');
    
    yyaxis(ax1f, 'right');
    plot(ax1f, f, y1, 'b-');
    yyaxis(ax1f, 'left');
    plot(ax1f, f, x1, 'r-');    
    plot(ax1f, f, r1, 'k-');

    yyaxis(ax2f, 'right');
    plot(ax2f, f, y2, 'b-');
    yyaxis(ax2f, 'left');
    plot(ax2f, f, x2, 'r-');
    plot(ax2f, f, r2, 'k-');
    
end