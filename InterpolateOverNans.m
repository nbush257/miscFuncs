function dataOUT = InterpolateOverNans(data,winsize)
%% dataOUT = InterpolateOverNans(data,winsize)
% =================================================
% Does linear interpolation over sequences of NaNs with a length less
% than winsize.  Retains NaNs at start and end of trial.
% ================================================
% INPUTS: data -
%
% OUTPUTS:
%
% ================================================
% First created by Mitra. Refactored NEB 2016_07_05
%% Input Handling
if ~isvector(data)
    error('Data is not a vector')
end
% make data a column vector
data = data(:);
% if there are no nans
if nn(data) == 0;
    dataOUT = data;
    warning('No NaNs found. Returning original vector')
    return
end

%% deal with two exceptional cases where first or last index is a nan,
% but not the second or second to last (respectively)

zeropad_start = [];
zeropad_stop = [];

if isnan(data(1)) && ~isnan(data(2))
    data(1) = data(2);
    zeropad_start = 1;
end

if isnan(data(end)) && ~isnan(data(end-1))
    data(end) = data(end-1);
    zeropad_stop = length(data);
end

%% Deal with starting or ending nans

% If data starts with NaNs, zeropad to first real number.

if isnan(data(1))
    a = ~isnan(data);
    b = find(a,1);  % this is the index of the first non-NaN
    idxval_start = b-1 ; % this is the index of the last NaN
    zeropad_start = 1:idxval_start;
    data(zeropad_start) = 0;
end;

% If data ends with NaNs, zeropad at the end;
if isnan(data(end))
    a = ~isnan(data);
    b = find(a,1,'last');  % this is the index of the last non-NaN at the end
    idxval_stop = b+1 ; % this is the index of the first NaN at the end
    zeropad_stop = idxval_stop:length(data);
    data(zeropad_stop) = 0;
end;

a = isnan(data);
b = diff(a);
starts = find(b == 1)+1;  % the index of the first NaN;
stops = find(b==-1) + 1;  % the index of the next non-NaN;

if ~isempty(starts)
    if length(starts) ~=length(stops)
        error('NaN segment starts does not equal the number of NaN segment stops.')
    else
        dataOUT = data;
        for ii = 1:length(starts)
            x1 = starts(ii)-1;
            x2 = stops(ii);
            y1 = data(x1);
            y2 = data(x2);
            m = (y2-y1)/(x2-x1);
            b = y1-m*x1;
            if x2-x1 < winsize
                dataOUT(x1:x2) = m*(x1:x2) + b;
            end;
        end;  % loop over starts
    end; % if the lengths of starts and stops is the same
end; % if starts is not empty


% Replace the NaNs removed at start and end
dataOUT(zeropad_start) = NaN;
dataOUT(zeropad_stop) = NaN;
