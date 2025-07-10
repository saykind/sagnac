function graphics = plot(graphics, logdata)
%Graphics plotting function.

    [ax_dc_dc, ax_dc_1f, ...
        ax_1f_RQ, ax_1f_XY, ax_2f_RQ, ax_2f_XY, ...
        ax_3f_RQ, ax_3f_XY, ax_4f_RQ, ax_4f_XY] = util.unpack(graphics.axes);

    for ax = util.unpack(graphics.axes);
        yyaxis(ax, 'left'); cla(ax);
        yyaxis(ax, 'right'); cla(ax);
    end

    curr = logdata.laser.I;
    dc = 1e3*logdata.lockin.auxin0(:,1);
    
    x1 = 1e3*logdata.lockin.x(:,1);
    y1 = 1e3*logdata.lockin.y(:,1);
    r1 = sqrt(x1.^2 + y1.^2);
    q1 = atan2d(y1, x1);

    x2 = 1e3*logdata.lockin.x(:,2);
    y2 = 1e3*logdata.lockin.y(:,2);
    r2 = sqrt(x2.^2 + y2.^2);
    q2 = atan2d(y2, x2);

    x3 = 1e3*logdata.lockin.x(:,3);
    y3 = 1e3*logdata.lockin.y(:,3);
    r3 = sqrt(x3.^2 + y3.^2);
    q3 = atan2d(y3, x3);

    x4 = 1e3*logdata.lockin.x(:,4);
    y4 = 1e3*logdata.lockin.y(:,4);
    r4 = sqrt(x4.^2 + y4.^2);
    q4 = atan2d(y4, x4);

    % Kerr angle
    kerr_x = util.math.kerr(x1, r2);
    kerr_y = util.math.kerr(y1, r2);
    r2n = r2./dc;

    % Coarse grain
    [CURR, DC, R2N, KERR_X, KERR_Y] =  util.coarse.sweep(logdata.sweep, curr, dc, r2n, kerr_x, kerr_y);

    %% TAB: Normalized
    yyaxis(ax_dc_dc, 'left');
    plot(ax_dc_dc, CURR, DC, 'r.-');
    yyaxis(ax_dc_dc, 'right');
    plot(ax_dc_dc, CURR, R2N, 'b.-');
    yyaxis(ax_dc_1f, 'left');
    plot(ax_dc_1f, CURR, KERR_X, 'r.-');
    yyaxis(ax_dc_1f, 'right');
    plot(ax_dc_1f, CURR, KERR_Y, 'b.-');
    
    %% TAB: 1f
    yyaxis(ax_1f_RQ, 'right');
    plot(ax_1f_RQ, curr, q1, 'b-');
    yyaxis(ax_1f_RQ, 'left');
    plot(ax_1f_RQ, curr, r1, 'r-');

    yyaxis(ax_1f_XY, 'right');
    plot(ax_1f_XY, curr, y1, 'b-');
    yyaxis(ax_1f_XY, 'left');
    plot(ax_1f_XY, curr, x1, 'r-');

    %% TAB: 2f
    yyaxis(ax_2f_RQ, 'right');
    plot(ax_2f_RQ, curr, q2, 'b-');
    yyaxis(ax_2f_RQ, 'left');
    plot(ax_2f_RQ, curr, r2, 'r-');

    yyaxis(ax_2f_XY, 'right');
    plot(ax_2f_XY, curr, y2, 'b-');
    yyaxis(ax_2f_XY, 'left');
    plot(ax_2f_XY, curr, x2, 'r-');

    %% TAB: 3f
    yyaxis(ax_3f_RQ, 'right');
    plot(ax_3f_RQ, curr, q3, 'b-');
    yyaxis(ax_3f_RQ, 'left');
    plot(ax_3f_RQ, curr, r3, 'r-');

    yyaxis(ax_3f_XY, 'right');
    plot(ax_3f_XY, curr, y3, 'b-');
    yyaxis(ax_3f_XY, 'left');
    plot(ax_3f_XY, curr, x3, 'r-');

    %% TAB: 4f
    yyaxis(ax_4f_RQ, 'right');
    plot(ax_4f_RQ, curr, q4, 'b-');
    yyaxis(ax_4f_RQ, 'left');
    plot(ax_4f_RQ, curr, r4, 'r-');
    
    yyaxis(ax_4f_XY, 'right');
    plot(ax_4f_XY, curr, y4, 'b-');
    yyaxis(ax_4f_XY, 'left');
    plot(ax_4f_XY, curr, x4, 'r-');
end