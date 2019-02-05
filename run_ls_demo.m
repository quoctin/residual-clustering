%--------------------------------------------------------------------------
% Copyright @ Quoc-Tin Phan, 2018-2020
%--------------------------------------------------------------------------

clear all
close all
clc

addpath('mex');

%% hyperparameters
% minimum number of neighbors in DBSCAN
MinPts              = 5; 
% path to data folder
db_path             = 'data';
% maximum number of fingerprints can be loaded on RAM
approx_chunk_size   = 4000;
optimize            = 1;
% dimension of fingerprints
data_dim            = 512*512;
% for fingerprints with dimension d = 512x512, lambda = 0.0018.
% to other value of d, a simple setting lambda = 1/sqrt(d) should work
lambda              = 0.0018;

%% setup data
% two data chunks, each contains up to 4000 fingerprints
% chunk 1 is split into two batches numbered as 1 & 2
% chunk 2 is split into two batches numbered as 3 & 4
% for example: in folder /data, 4 mat files are available for large-scale
% clustering: 'test_ls_data_batch_1.mat', 'test_ls_data_batch_2.mat', 
%             'test_ls_data_batch_3.mat', 'test_ls_data_batch_4.mat'
% only one chunk is loaded at once.
% the following parameters can be re-configured according to RAM size.
db      = 'test_ls_data';
nchunks = 2; 
batches = {[1,2],[3,4]};

%% initialization
data_info.nchunks           = nchunks;
data_info.approx_chunk_size = approx_chunk_size;
data_info.batches           = batches;
data_info.data_dim          = data_dim;
data_info.db                = db;
dbscan_para.MinPts          = MinPts;
ls_clustering               = LS_Clustering(data_info, dbscan_para, lambda);

%% run large-scale clustering algorithm
addpath(db_path);
[segmentation, gt_labels, times] = ls_clustering.run();
fprintf('\nNumber of unclustered fingerprints: %f\n', sum(segmentation(:,1) == 0));
fprintf('\nIO+data preparing \t (%.2f secs)\n', times.t1);
fprintf('\nComputation time \t (%.2f secs)\n', times.t2);
