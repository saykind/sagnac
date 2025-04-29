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

    z = logdata.Z.position;
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
    aux1 = aux1 + 6;
    %aux2 = 1e3*logdata.lockin.auxin1(:,1);

    try
        [z, aux1, x1, y1, r1, q1, x2, y2, r2, q2, x3, y3, r3, q3] = ...
            util.coarse.sweep(logdata.sweep, z, aux1, x1, y1, r1, q1, x2, y2, r2, q2, x3, y3, r3, q3);
    catch
        util.msg('Problem with util.coarse.sweep.');
    end

    % Normalize
    r1n = r1./aux1;
    r2n = r2./aux1;

    %% TAB: Normalized
    plot(ax_dc_dc, z, aux1, 'k-');
    plot(ax_dc_1f, z, 1e3*r1n, 'k-');
    plot(ax_dc_2f, z, 1e3*r2n, 'k-');
    
    %% TAb: 1f
    yyaxis(ax_1f_RQ, 'right');
    plot(ax_1f_RQ, z, q1, 'b-');
    yyaxis(ax_1f_RQ, 'left');
    plot(ax_1f_RQ, z, r1, 'r-');

    yyaxis(ax_1f_XY, 'right');
    plot(ax_1f_XY, z, y1, 'b-');
    yyaxis(ax_1f_XY, 'left');
    plot(ax_1f_XY, z, x1, 'r-');

    %% TAB: 2f
    yyaxis(ax_2f_RQ, 'right');
    plot(ax_2f_RQ, z, q2, 'b-');
    yyaxis(ax_2f_RQ, 'left');
    plot(ax_2f_RQ, z, r2, 'r-');

    yyaxis(ax_2f_XY, 'right');
    plot(ax_2f_XY, z, y2, 'b-');
    yyaxis(ax_2f_XY, 'left');
    plot(ax_2f_XY, z, x2, 'r-');

    %% TAB: 3f
    yyaxis(ax_3f_RQ, 'right');
    plot(ax_3f_RQ, z, q3, 'b-');
    yyaxis(ax_3f_RQ, 'left');
    plot(ax_3f_RQ, z, r3, 'r-');

    yyaxis(ax_3f_XY, 'right');
    plot(ax_3f_XY, z, y3, 'b-');
    yyaxis(ax_3f_XY, 'left');
    plot(ax_3f_XY, z, x3, 'r-');
    
end