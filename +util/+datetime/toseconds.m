function s = toseconds(d)
    s = dot((d(3:end).*[24*60*60, 60*60, 60, 1]), ones(1, 4));
end