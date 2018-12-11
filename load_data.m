%--------------------------------------------------------------------------
% Copyright @ Quoc-Tin Phan, 2018-2020
%--------------------------------------------------------------------------

function [X, labels] = load_data(data_name)
%%	This function loads and standardize data
%   Input:
%       data_name: a string, name of mat file containing X and labels (if
%       applicable)
%   Output:
%       X: dxn matrix, d: number of features, n: number of examples
%   Usage: 
%       [X, labels] = load_data('test')
%%	.

    load(data_name);
    X = data_normalization(X);
    if ~exist('labels', 'var')
        labels = [];
    end
end

