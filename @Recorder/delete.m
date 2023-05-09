function delete(obj)
    if obj.verbose, disp('[Recorder] destructed.'); end
    if ~isempty(obj.logger), obj.logClear(); end
end