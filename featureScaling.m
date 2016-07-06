function X_out = featureScaling(X)
%% function X_out = featureScaling(X)
% this is a shortcut for performing feature scaling on a matrix of values.
% Each row is an observation, each column is a feature.

% subtract mean and divide by standard deviation.

% NEB 2016_06_08
%%
d = bsxfun(@minus,X,nanmean(X));
X_out = bsxfun(@rdivide, d,nanstd(X));