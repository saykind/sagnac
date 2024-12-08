function [F,A,R0] = plot(graphics, logdata)
%Graphics plotting function.

    [ax_0f, ax_1f, ax_2f, ax_3f] = util.unpack(graphics.axes);
    for ax = [ax_0f, ax_1f, ax_2f, ax_3f]
        cla(ax);
    end

    %f = 1e-6*logdata.lockin.oscillator_frequency(:,1);
    %a = logdata.lockin.output_amplitude(:,1);

    f = 1e-6*logdata.sweep.range(1,:);
    a = logdata.sweep.range(2,:);

    r0 = 1e3*logdata.lockin.auxin0(:,1);
    x1 = 1e6*logdata.lockin.x(:,1);
    y1 = 1e6*logdata.lockin.y(:,1);
    r1 = sqrt(x1.^2 + y1.^2);
    x2 = 1e3*logdata.lockin.x(:,2);
    y2 = 1e3*logdata.lockin.y(:,2);
    r2 = sqrt(x2.^2 + y2.^2);
    x3 = 1e6*logdata.lockin.x(:,3);
    y3 = 1e6*logdata.lockin.y(:,3);
    r3 = sqrt(x3.^2 + y3.^2);

    [R0, R1, R2, R3] = util.coarse.sweep(logdata.sweep, r0, r1, r2, r3);
    [F, A, R0, R1, R2, R3] = util.mesh.reshape(logdata.sweep.shape, f, a, R0, R1, R2, R3);

    surf(ax_0f, F, A, R0, 'EdgeAlpha', .2);
    surf(ax_1f, F, A, R1, 'EdgeAlpha', .2);
    surf(ax_2f, F, A, R2, 'EdgeAlpha', .2);
    surf(ax_3f, F, A, R3, 'EdgeAlpha', .2);
    
end