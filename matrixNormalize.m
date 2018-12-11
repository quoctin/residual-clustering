%--------------------------------------------------------------------------
% Copyright @ Quoc-Tin Phan, 2018-2020
%--------------------------------------------------------------------------

function Xp = matrixNormalize(X)
%	This function normalizes each column of X to unit norm
%   X is DxN matrix
    [D,N] = size(X);
    Xp = zeros(D,N);
    for i = 1:N
        Xp(:,i) = X(:,i) ./ norm(X(:,i));
    end
end