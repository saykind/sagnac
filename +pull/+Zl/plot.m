function graphics = plot(graphics, logdata)
%Graphics plotting function.

    [ax_dc_dc, ax_dc_1f, ax_dc_2f, ...
        ax_1f_RQ, ax_1f_XY, ax_2f_RQ, ax_2f_XY, ...
        ax_3f_RQ, ax_3f_XY, ax_4f_RQ, ax_4f_XY] = util.unpack(graphics.axes);
    for ax = [ax_dc_dc, ax_dc_1f, ax_dc_2f]
        cla(ax);
    end
    for ax = [ax_1f_RQ, ax_1f_XY, ax_2f_RQ, ax_2f_XY, ax_3f_RQ, ax_3f_XY, ax_4f_RQ, ax_4f_XY]
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

    % Normalize
    dc_avg = mean(dc);
    r1n = r1/dc_avg;
    r2n = r2/dc_avg;

    %% TAB: Normalized
    plot(ax_dc_dc, curr, dc, 'k-');
    plot(ax_dc_1f, curr, 1e3*r1n, 'k-');
    plot(ax_dc_2f, curr, 1e3*r2n, 'k-');
    
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