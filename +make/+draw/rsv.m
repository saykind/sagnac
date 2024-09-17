function graphics = rsv(graphics, logdata)
%Graphics plotting function.

    axisA = graphics.axes(1);
    cla(axisA);

    v = 25*logdata.lockin.AUXV1;   % Blue box gain of 25
    x = logdata.lockin.X;
    r = x/100;                      % gain of 100 from pre-amp
    r = 1e6*r;                      % Current of 1 mA (5V into 5k resistor) hence 1uV = 1mOhm

    plot(axisA, v, r, 'Color', 'r');
    
end