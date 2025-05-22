function v0 = dc(lockin, options)
%DC extract dc voltage angle data from lockin data structure array.
%
% Example:
%   v0 = util.logdata.ldcockin(logdata.lockin);

arguments
    lockin (1,:) struct
    options.verbose (1,1) logical = false       % Display progress
end

    v0 = lockin.auxin0(:,1);

end