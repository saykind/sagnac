function graphics = plot(graphics, logdata)
%Graphics plotting function.

    [ax_dc_dc, ax_dc_1f, ax_dc_2f, ...
        ax_1f_RQ, ax_1f_XY, ...
        ax_2f_RQ, ax_2f_XY, ...
        ax_3f_RQ, ax_3f_XY] = util.unpack(graphics.axes);
    for ax = [ax_dc_dc, ax_dc_1f, ax_dc_2f]
        cla(ax);
    end
    for ax = [ax_1f_RQ, ax_1f_XY, ax_2f_RQ, ax_2f_XY, ax_3f_RQ, ax_3f_XY]
        yyaxis(ax, 'left'); cla(ax);
        yyaxis(ax, 'right'); cla(ax);
    end

    y = logdata.Y.position;
    y = y - mean(y);
    y = 1e3*y; % mm to um

    x1 = 1e6*logdata.lockin.x(:,1);
    y1 = 1e6*logdata.lockin.y(:,1);
    r1 = sqrt(x1.^2 + y1.^2);
    q1 = atan2d(y1, x1);
    x2 = 1e3*logdata.lockin.x(:,2);
    y2 = 1e3*logdata.lockin.y(:,2);
    r2 = sqrt(x2.^2 + y2.^2);
    q2 = atan2d(y2, x2);
    x3 = 1e6*logdata.lockin.x(:,3);
    y3 = 1e6*logdata.lockin.y(:,3);
    r3 = sqrt(x3.^2 + y3.^2);
    q3 = atan2d(y3, x3);
    aux1 = 1e3*logdata.lockin.auxin0(:,1);
    aux1 = aux1 + 8;
    %aux2 = 1e3*logdata.lockin.auxin1(:,1);

    try
        [y, aux1, x1, y1, r1, q1, x2, y2, r2, q2, x3, y3, r3, q3] = ...
            util.coarse.sweep(logdata.sweep, y, aux1, x1, y1, r1, q1, x2, y2, r2, q2, x3, y3, r3, q3);
    catch
        util.msg('Problem with util.coarse.sweep.');
    end

    % Normaliye
    r1n = r1./aux1;
    r2n = r2./aux1;

    %% TAB: Normalized
    plot(ax_dc_dc, y, aux1, 'k-');
    plot(ax_dc_1f, y, 1e3*r1n, 'k-');
    plot(ax_dc_2f, y, 1e3*r2n, 'k-');
    
    %% TAb: 1f
    yyaxis(ax_1f_RQ, 'right');
    plot(ax_1f_RQ, y, q1, 'b-');
    yyaxis(ax_1f_RQ, 'left');
    plot(ax_1f_RQ, y, r1, 'r-');

    yyaxis(ax_1f_XY, 'right');
    plot(ax_1f_XY, y, y1, 'b-');
    yyaxis(ax_1f_XY, 'left');
    plot(ax_1f_XY, y, x1, 'r-');

    %% TAB: 2f
    yyaxis(ax_2f_RQ, 'right');
    plot(ax_2f_RQ, y, q2, 'b-');
    yyaxis(ax_2f_RQ, 'left');
    plot(ax_2f_RQ, y, r2, 'r-');

    yyaxis(ax_2f_XY, 'right');
    plot(ax_2f_XY, y, y2, 'b-');
    yyaxis(ax_2f_XY, 'left');
    plot(ax_2f_XY, y, x2, 'r-');

    %% TAB: 3f
    yyaxis(ax_3f_RQ, 'right');
    plot(ax_3f_RQ, y, q3, 'b-');
    yyaxis(ax_3f_RQ, 'left');
    plot(ax_3f_RQ, y, r3, 'r-');

    yyaxis(ax_3f_XY, 'right');
    plot(ax_3f_XY, y, y3, 'b-');
    yyaxis(ax_3f_XY, 'left');
    plot(ax_3f_XY, y, x3, 'r-');
    
end