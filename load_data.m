%--------------------------------------------------------------------------
% Copyright @ Quoc-Tin Phan, 2017
%--------------------------------------------------------------------------

function [X, labels] = load_data(data_name, batches)
%%	This function loads and standardize data
%   Input:
%       data_name: a string, name of mat file containing X and labels (if
%       applicable). In large-scale context, data can compose of multiple
%       batches with the suffix "_batch_[batch number]"
%       batches (optional): 1d array of batch numbers
%   Output:
%       X: dxn matrix, d: number of features, n: number of examples
%   Usage: 
%       [X, labels] = load_data('test') to load 'test.mat'
%       or
%       [X, labels] = load_data('test', [1,2]) to load 'test_batch_1.mat'
%                     and 'test_batch_2.mat' jointly
%%	.
	
    if nargin < 2
        batches = [];
    end
    
    if ~isempty(batches)
        X_full = [];
        labels_full = [];
        for i = 1:length(batches)
            file_name = [data_name '_batch_' num2str(batches(i)) '.mat'];
            load(file_name);
            X_full = [X_full X];
            labels_full = [labels_full labels];
            clearvars -except X_full labels_full data_name batches
        end
        X = X_full;
        labels = labels_full;
        clearvars X_full labels_full
    else
        load(data_name);
        image_paths = [];
    end
    X = data_normalization(X);
end

