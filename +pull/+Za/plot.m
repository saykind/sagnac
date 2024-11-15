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

    a = logdata.lockin.output_amplitude(:,1);
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
    plot(ax_dc_dc, a, dc, 'k-');
    plot(ax_dc_1f, a, 1e3*r1n, 'k-');
    plot(ax_dc_2f, a, 1e3*r2n, 'k-');
    
    %% TAB: 1f
    yyaxis(ax_1f_RQ, 'right');
    plot(ax_1f_RQ, a, q1, 'b-');
    yyaxis(ax_1f_RQ, 'left');
    plot(ax_1f_RQ, a, r1, 'r-');
    
    % Fit r1 to linear, set intercept to 0
    % a1_ = a(a < 0.5);
    % r1_ = r1(a < 0.5);
    % r1_ideal = @(x, a) x(1)*a;
    % x0 = 3;
    % x = lsqcurvefit(r1_ideal, x0, a1_, r1_);
    % r1_fit = r1_ideal(x, a);
    % plot(ax_1f_RQ, a, r1_fit, 'r--');
    % fprintf("r1 = %.4f a\n", x(1));

    yyaxis(ax_1f_XY, 'right');
    plot(ax_1f_XY, a, y1, 'b-');
    yyaxis(ax_1f_XY, 'left');
    plot(ax_1f_XY, a, x1, 'r-');

    %% TAB: 2f
    yyaxis(ax_2f_RQ, 'right');
    plot(ax_2f_RQ, a, q2, 'b-');
    yyaxis(ax_2f_RQ, 'left');
    plot(ax_2f_RQ, a, r2, 'r-');

    % fit r2 to quadratic
    % a2_ = a(a < 1);
    % r2_ = r2(a < 1);
    % r2_ideal = @(x, a) x*a.^2;
    % x0 = .3;
    % x = lsqcurvefit(r2_ideal, x0, a2_, r2_);
    % r2_fit = r2_ideal(x, a);
    % plot(ax_2f_RQ, a, r2_fit, 'r--');
    % fprintf("r2 = %.4f a^2\n", x(1));

    yyaxis(ax_2f_XY, 'right');
    plot(ax_2f_XY, a, y2, 'b-');
    yyaxis(ax_2f_XY, 'left');
    plot(ax_2f_XY, a, x2, 'r-');

    %% TAB: 3f
    yyaxis(ax_3f_RQ, 'right');
    plot(ax_3f_RQ, a, q3, 'b-');
    yyaxis(ax_3f_RQ, 'left');
    plot(ax_3f_RQ, a, r3, 'r-');

    % fit r3 to cubic
    % a3_ = a(a < 1);
    % r3_ = r3(a < 1);
    % r3_ideal = @(x, a) x(1)*a.^3;
    % x0 = .06;
    % x = lsqcurvefit(r3_ideal, x0, a3_, r3_);
    % r3_fit = r3_ideal(x, a);
    % plot(ax_3f_RQ, a, r3_fit, 'r--');
    % fprintf("r3 = %.4f a^3\n", x(1));

    yyaxis(ax_3f_XY, 'right');
    plot(ax_3f_XY, a, y3, 'b-');
    yyaxis(ax_3f_XY, 'left');
    plot(ax_3f_XY, a, x3, 'r-');

    %% TAB: 4f
    yyaxis(ax_4f_RQ, 'right');
    plot(ax_4f_RQ, a, q4, 'b-');
    yyaxis(ax_4f_RQ, 'left');
    plot(ax_4f_RQ, a, r4, 'r-');
    
    yyaxis(ax_4f_XY, 'right');
    plot(ax_4f_XY, a, y4, 'b-');
    yyaxis(ax_4f_XY, 'left');
    plot(ax_4f_XY, a, x4, 'r-');
end