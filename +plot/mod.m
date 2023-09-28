function mod(a0, f0)
%Make colorplot of ideal modulation sweep


    %% Header
    if nargin < 1, a0=1.1; end
    if nargin < 2, f0=4.84; end

    f = figure('Units', 'centimeters');
    set(f,  'Position',  [0, 0, 40, 24]);
    tl = tiledlayout(f, 2, 2);

    axisA = nexttile(tl);
    axisB = nexttile(tl);
    axisC = nexttile(tl);
    axisD = nexttile(tl);

    a = [axisA, axisB, axisC, axisD];

    title(axisA, 'DC power P_0, \muW');
    title(axisB, 'AC power P_1, \muW');
    title(axisC, 'AC power P_2, \muW');
    title(axisD, 'Phase');
    colorbar(axisA);
    colorbar(axisB);
    colorbar(axisC);
    colorbar(axisD);

    for i = 1:length(a)
        axis = a(i);
        hold(axis, 'on');
        grid(axis, 'on');
        set(axis,'Units', 'centimeters');
        set(axis, 'FontSize', 12, 'FontName', 'Arial');
        ylabel(axis, "Amplitude Vpp, V");
        xlabel(axis, "Frequency f, MHz");
    end
    
    %% Plot
    f1 = 0:.05:10;
    a1 = 0:.02:5;
    [f,a] = meshgrid(f1,a1);
    phi = 2*0.92*a/a0.*sin(pi/2*f/f0);
    theta = 1e-3;
    p0 = 1+besselj(0,phi);
    p1 = 2*besselj(1,phi)*theta;
    p2 = 2*besselj(2,phi);

    surf(axisA, f, a, p0, 'EdgeAlpha', 0);
    surf(axisB, f, a, abs(p1), 'EdgeAlpha', 0);
    surf(axisC, f, a, abs(p2), 'EdgeAlpha', 0);
    surf(axisD, f, a, phi, 'EdgeAlpha', 0);

end

