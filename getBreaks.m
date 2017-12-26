function [starts,stops] = getBreaks(d_cell,breaks,spec)
%% function [start,stop] = getBreaks(d_combined,spec)
% this function returns the indices of a particular file starting and
% stopping from the concatenated C vector that was found using the Neural
% network
idx = find(~cellfun(@isempty,regexp(d_cell,spec)));
starts = breaks(idx)+1;
stops = breaks(idx+1);
