%--------------------------------------------------------------------------
% Copyright @ Quoc-Tin Phan, 2018-2020
%--------------------------------------------------------------------------

clear
close all
clc

addpath('data', 'kmeans', 'mex');

%% some parameters
% for fingerprints with dimension d = 512x512, lambda = 0.0018.
% to other value of d, a simple setting lambda = 1/sqrt(d) should work
lambda = 0.0018;
data_name = 'test_data';

%% load data and run clustering
[X, labels] = load_data(data_name);
tic
CMat = solve_l1_optimization_ADMM_fast(X, lambda);
[K, segmentation] = Clustering(CMat);

fprintf('\nRunning time: %.2f seconds\n', toc);
fprintf('\nNumber of clusters: %d\n', K);
