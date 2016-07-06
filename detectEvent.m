function [ons,offs] = detectEvent(x,varargin)
%% function y = detectEvent(x,[threshold],[method])
% ======================================
% Detects when a signal goes high or low. Can be usefull for detecting when
% TTL pulses are on/off.
% ======================================
% INPUTS:
%           x - a 1 dimensional vector where you want to detect if
%           something changes by a certain threshold 
%           
%           [threshold] - number of standard deviations the signal must
%           change by in order to count as a change. Default is 3
%           
%           [method] - either 'findpeaks' or 'diff'. Determines whether we
%           use the findpeaks algorithm builtin by matlab, or an algorithm
%           that thresholds the signal and finds where it changes. 'diff'
%           is useful for TTLs. Default is 'findpeaks'
% =======================================
% OUTPUTS:
%           ons - a column vector of indices of x where a large postive
%           change occurred
%
%           offs - a column vector of indices of x where a large negative
%           change occured.
% =======================================
% NEB 2016_06_28
%% Varargin handling
numvargs = length(varargin);
optargs = {5,'findpeaks'};
optargs(1:numvargs) = varargin(:);
[thresh,method] =optargs{:};
%% 
if ~ismember(method, {'diff','findpeaks'})
    error('Not a valid method')
end

if ~any(size(x)==1)
    error('Input is not a vector.')
end
%%
% make x a column vector
x = x(:);
%%
switch method
    case 'findpeaks'
        %get diff
        d = [0;diff(x)];

        [h,ons] = findpeaks(d,'MinPeakProminence',thresh);
        [h,offs] = findpeaks(-d,'MinPeakProminence',thresh);

    case 'diff'
        y = false(size(x));
        y(x > std(x)) = 1;
        
        d = [0;diff(y)];
        ons = find(d ==1);
        offs = find(d ==-1);
end

