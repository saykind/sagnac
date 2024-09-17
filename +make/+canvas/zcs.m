function graphics = zcs()
%Graphics initialization function.

    f = figure('Units', 'centimeters');

    set(f,  'Position',  [0, 0, 24, 15]);
    tl = tiledlayout(f,3,1);

    axisA = nexttile(tl);
    hold(axisA, 'on');
    grid(axisA, 'on');
    title(axisA, 'Current sweep');
    set(axisA, 'Units', 'centimeters');
    set(axisA, 'FontSize', 12, 'FontName', 'Arial');
    yyaxis(axisA, 'right');
    set(axisA, 'YColor', 'b');
    ylabel(axisA, "DC Voltage, mV");
    yyaxis(axisA, 'left');
    set(axisA, 'YColor', 'r');
    ylabel(axisA, "Kerr, \murad");

    axisB = nexttile(tl);
    hold(axisB, 'on');
    grid(axisB, 'on');
    set(axisB, 'Units', 'centimeters');
    set(axisB, 'FontSize', 12, 'FontName', 'Arial', 'YColor', 'r');
    set(axisB, 'FontSize', 12, 'FontName', 'Arial');
    yyaxis(axisB, 'right');
    set(axisB, 'YColor', 'b');
    ylabel(axisB, "1\omega Voltage Y, \muV");
    yyaxis(axisB, 'left');
    set(axisB, 'YColor', 'r');
    ylabel(axisB, "1\omega Voltage X, \muV");

    axisC = nexttile(tl);
    hold(axisC, 'on');
    grid(axisC, 'on');
    set(axisC, 'Units', 'centimeters');
    set(axisC, 'FontSize', 12, 'FontName', 'Arial', 'YColor', 'r');
    set(axisC, 'FontSize', 12, 'FontName', 'Arial');
    yyaxis(axisC, 'right');
    set(axisC, 'YColor', 'b');
    ylabel(axisC, "2\omega Voltage V_{2Y}, mV");
    yyaxis(axisC, 'left');
    set(axisC, 'YColor', 'r');
    ylabel(axisC, "2\omega Voltage V_{2X}, mV");
    xlabel(axisC, "Current, mA");

    a = [axisA, axisB, axisC];

    graphics = struct('figure', f, 'axes', a);

end