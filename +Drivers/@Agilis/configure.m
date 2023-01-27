function configure(obj)
%Entering and leaving CONFIGURATION state.

    state = obj.st();
    if strcmp(state, "CONFIGURATION")
        obj.write("1PW0");
        warning("Execution may take up to 10 seconds. Controller will not respond to any other command.")
        return
    end
    warn = 'There is 100 hardware times limit on entering/leaving CONFIGURATION state.\n';
    ing = 'Are you sure? (y/N) ';
    answer = input([warn, ing], "s");
    if strcmp(answer, 'y')
        disp("Configuration state is not supported.");
    end
end