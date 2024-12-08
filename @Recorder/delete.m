function delete(obj)
    if obj.verbose, util.msg('destructed.'); end
    if ~isempty(obj.logger), obj.logClear(); end
end