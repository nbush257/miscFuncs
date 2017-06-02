function y = pastShift(x,nShift,varargin)
%% function y = pastShift(x,nShift,[pad])
% shifts a vector so that times occur nShift bins later, useful for
% looking into the past in a glm.
% NEB
%%
if nargin ==3
    pad = varargin{1};
else
    pad = 0;
end

if isrow(x);x=x';end
y = [repmat(pad,nShift,1);x(1:end-nShift)];
