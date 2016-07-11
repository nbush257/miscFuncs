function X_out = featureScaling(X,varargin)
%% function X_out = featureScaling(X,[method])
% this is a shortcut for performing feature scaling on a matrix of values.
% Each row is an observation, each column is a feature.

% subtract mean and divide by standard deviation.

% NEB 2016_06_08
if length(varargin)==1
    method = varargin{1};
else
    method = 'std';
end
    
%%
if size(X,1)<size(X,2)
    X = X';
    warning('Input matrix had more columns than rows. Taking the transpose.')
end

switch method
    case 'std'
        disp('using standard deviation scaling')
        d = bsxfun(@minus,X,nanmean(X));
        X_out = bsxfun(@rdivide, d,nanstd(X));
    case 'minmax'
        disp('using standard min max scaling')
        d = bsxfun(@minus,X,nanmean(X));
        X_out = bsxfun(@rdivide,d,max(X)-min(X));
    
end
