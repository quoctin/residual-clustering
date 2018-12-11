%--------------------------------------------------------------------------
% Copyright @ Quoc-Tin Phan, 2018-2020
%--------------------------------------------------------------------------

function X = data_normalization(X)
%%  This function normalizes every column of X to zero mean
%   and unit variance
%% .
    M = mean(X);
    STD = std(X);
    X = bsxfun(@minus, X, M);
    X = bsxfun(@rdivide, X, STD);
end

