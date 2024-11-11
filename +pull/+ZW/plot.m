function graphics = plot(graphics, logdata)
%Graphics plotting function.

    [ax_dc_dc, ax_dc_1f, ax_dc_2f, ax_1f_RQ, ax_1f_XY, ax_2f_RQ, ax_2f_XY] = util.unpack(graphics.axes);
    for ax = [ax_dc_dc, ax_dc_1f, ax_dc_2f]
        cla(ax);
    end
    for ax = [ax_1f_RQ, ax_1f_XY, ax_2f_RQ, ax_2f_XY]
        yyaxis(ax, 'left'); cla(ax);
        yyaxis(ax, 'right'); cla(ax);
    end

    angle = logdata.waveplate.angle;
    x1 = 1e3*logdata.lockin.x(:,1);
    y1 = 1e3*logdata.lockin.y(:,1);
    r1 = sqrt(x1.^2 + y1.^2);
    q1 = atan2d(y1, x1);
    x2 = 1e3*logdata.lockin.x(:,2);
    y2 = 1e3*logdata.lockin.y(:,2);
    r2 = sqrt(x2.^2 + y2.^2);
    q2 = atan2d(y2, x2);
    aux1 = 1e3*logdata.lockin.auxin0(:,1);
    %aux2 = 1e3*logdata.lockin.auxin1(:,1);

    % Normalize
    dc_avg = mean(aux1);
    r1n = r1/dc_avg;
    r2n = r2/dc_avg;

    %% TAB: Normalized
    plot(ax_dc_dc, angle, aux1, 'k-');
    plot(ax_dc_1f, angle, 1e3*r1n, 'k-');
    plot(ax_dc_2f, angle, 1e3*r2n, 'k-');
    
    %% TAb: 1f
    yyaxis(ax_1f_RQ, 'right');
    plot(ax_1f_RQ, angle, q1, 'b-');
    yyaxis(ax_1f_RQ, 'left');
    plot(ax_1f_RQ, angle, r1, 'r-');

    yyaxis(ax_1f_XY, 'right');
    plot(ax_1f_XY, angle, y1, 'b-');
    yyaxis(ax_1f_XY, 'left');
    plot(ax_1f_XY, angle, x1, 'r-');

    %% TAB: 2f
    yyaxis(ax_2f_RQ, 'right');
    plot(ax_2f_RQ, angle, q2, 'b-');
    yyaxis(ax_2f_RQ, 'left');
    plot(ax_2f_RQ, angle, r2, 'r-');

    yyaxis(ax_2f_XY, 'right');
    plot(ax_2f_XY, angle, y2, 'b-');
    yyaxis(ax_2f_XY, 'left');
    plot(ax_2f_XY, angle, x2, 'r-');
    
end