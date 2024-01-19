function sim_sweep(s)
    %Simulates actions of sweep function and makes a plot.
    %Input s is a sweep structure with fields 'rate', 'pause', 'range'.
    
    t_max = s.rate*length(s.range)-2;
    rec = zeros(1,t_max);
    val = zeros(1,t_max);
    rec_current = -.1;
    val_current = -.1;
    cn = 0;

    for t = 1:t_max
        cn = cn+1;
        c = cn+2*s.rate;
        if rem(c, s.rate) > s.rate-2
            try
                i = fix(c/s.rate);
                val_current = s.range(i);
                rec_current = 0;
            catch
                fprintf("Error at t=%d, c=%d\n", t, c);
            end
        end
        if rem(c-s.pause, s.rate) > s.rate-2
            rec_current = .1;
        end
        val(t) = val_current;
        rec(t) = rec_current;
    end
    figure();
    hold on;
    plot(val, 'r.-');
    yyaxis 'right';
    plot(rec, 'b.');
    legend(["values", "rec"]);
end