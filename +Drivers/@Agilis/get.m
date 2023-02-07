function varargout = get(obj, varargin)
    %Parameter/value get method
    %
    %   Usage example:
    %   obj.get('id');
    %   [id, pos] = obj.get('id', 'position');

    for i = 1:(nargin-1)
        switch varargin{i}
            case {'id', 'ID'}
                id = obj.query("1ID?");
                obj.id = id;
                obj.serial = extractBetween(obj.id(),19,26);
                varargout{i} = id;
                
            case {'state', 'STATE'}
                state_str = convertStringsToChars(obj.query("1TS?"));
                state_hex = state_str(8:9);
                state_num = hex2dec(state_hex);
                obj.state_hex = state_hex;
                obj.state_num = state_num;
                state_num = fix(state_num/10);
                state = "UNDETERMINED";
                if state_num == 1
                    state = "NOT REFERENCED";
                end
                if state_num == 2
                    state = "CONFIGURATION";
                end
                if state_num == 3
                    state = "HOMING";
                end
                if state_num == 4
                    state = "MOVING";
                end
                if state_num == 5
                    state = "READY";
                end
                if state_num == 6
                    state = "DISABLE";
                end
                obj.state = state;
                varargout{i} = state;
                
            case {'error', 'err', 'ERR', 'ERROR'}
                err = convertStringsToChars(obj.query("1TE"));
                err = err(4);
                obj.error = err;
                varargout{i} = err;
                err_str = extractAfter(obj.query(['1TB',err]), 5);
                obj.error_str = err_str;
                varargout{i} = err_str;
                
            case {'if', 'IF', 'factor'}
                factor_str = obj.query("1IF?");
                factor = str2num(extractAfter(factor_str,3));
                obj.factor = factor;
                varargout{i} = factor;
                
            case {'step', 'inc', 'unit'}
                unit_str = obj.query("1SU?");
                unit = str2num(extractAfter(unit_str,3));
                obj.unit = unit;
                varargout{i} = unit;
            
            case {'deadband', 'db'}
                db_str = obj.query("1DB?");
                db = str2num(extractAfter(db_str,3));
                obj.deadband = db;
                varargout{i} = db;
                
            case {'home', 'hometype'}
                home_str = obj.query("1HT?");
                hometype = str2num(extractAfter(home_str,3));
                obj.hometype = hometype;
                varargout{i} = hometype;
                
            case {'position', 'pos', 'x', 'X'}
                pos_str = obj.query("1TP?");
                pos = str2num(extractAfter(pos_str,3));
                obj.position = pos;
                varargout{i} = pos;
                
            case {'neglim', 'nlim', 'negativelimit'}
                lim_str = obj.query("1SL?");
                lim = str2num(extractAfter(lim_str,3));
                obj.neglim = lim;
                varargout{i} = lim;
                
            case {'poslim', 'plim', 'positivelimit'}
                lim_str = obj.query("1SR?");
                lim = str2num(extractAfter(lim_str,3));
                obj.poslim = lim;
                varargout{i} = lim;
        end
    end

    
end