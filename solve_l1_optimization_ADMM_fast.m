%--------------------------------------------------------------------------
% Copyright @ Quoc-Tin Phan, 2018-2020
%--------------------------------------------------------------------------

function Z = solve_l1_optimization_ADMM_fast(X, lambda)
%%  This function solves the optimization problem:
%   min lambda*||Z||_1 + ||XZ-X||^2_F s.t. diag(Z) = 0, Z >= 0 
%   Input:
%       X: dxn matrix, d: the number of features, n: number of examples 
%       lambda: regularization parameter
%   Output:
%       Z: nxn matrix
%% .
    Xp = matrixNormalize(X);
    Z = mexLassoFast(Xp, lambda, 1.0, 1.0, 10^3, 10^-4);
end
