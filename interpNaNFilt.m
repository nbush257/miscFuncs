function xOut = interpNaNFilt (x,sr,lp,varargin)
%% function xOut = interpNaNFilt (x,sr,lp,[winsize])
% ==================================================
% Applies an acausal lowpass filter to a vector x which contains NaNs. This
% is particularly useful if you have many whisks intervening with NaN
% sections. It will also fill in NaN gaps if desired (defaults to fill gaps 
% less than 10 ms)
% ===================================================
%   INPUTS:
%           x - a vector of some signal you want to filter
%           sr - sampling rate in Hz.
%           lp - lowpass threshold to filter at
%           [winsize] - size of window at which you want to fill small gaps.
%              Default is 10 ms
%   OUPTUTS:
%           xOut - a filtered version of x
% ====================================================
% Originally part of EDA toolbox. Refactored by NEB 2016_07_06
%% varargin handling

narginchk(3,4);
numvargs = length(varargin);
optargs = {10}; % winsize in ms. Default is 10 ms
optargs(1:numvargs) = varargin;
[winsize] = optargs{:};

%%
winsize = sr/1000*winsize; % convert winsize into samples

if ~isvector(x)
    error('Input is not a vector')
end
% make x a column vector
x = x(:);

% remove small gaps if desired. Default is 10 ms. Skips if the gap is zero
if winsize >0
    x = InterpolateOverNans(x,winsize);
end

%% find not NaN segments to filter
xOut = NaN(size(x));

notNan = ~isnan(x); % first find where it is not a NaN
notNaN = [0; notNan; 0]; % add these for easier diffing (and force first frame to be a start)
difNaN = diff(notNaN);
starts = find(difNaN == 1);  % mark where all nonNaN segments START
stops = find(difNaN == -1) - 1; % mark where all nonNaN segments END
nsegs = length(starts); % how many nonNaN segments are there

%% Loop over not nan segments and filter them
for ii = 1:nsegs
    inds = starts(ii):stops(ii);
    
    % skip the filtering if the segment is less than 6 points long
    if length(inds)<=6
        continue
    end
    
    xOut(inds) = bwfilt(x(inds),sr,0,lp);% 
end