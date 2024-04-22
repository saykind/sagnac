function remote(obj)
%Switch to remote mode.
%   Use 'mode 3' to switch to remote with local lockout.
    obj.write('mode 2');
end