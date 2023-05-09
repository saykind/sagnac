function s = datetimeToSeconds(d)
    s = dot((d(3:end).*[24*60*60 60*60 60 1]),[1 1 1 1]);
end