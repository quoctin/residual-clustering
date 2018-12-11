%--------------------------------------------------------------------------
% Copyright @ Quoc-Tin Phan, 2018-2020
%--------------------------------------------------------------------------

function [K,grps] = Clustering(CMat, K)
%%  This function performs Sparse Subspace Clustering on sparse representation matrix
%   CMat is NxN matrix containing parse solutions of N samples as columns
%   Input:
%       CMat: the sparse representation matrix
%       K (optional): the number of clusters. If K isn't given, it is
%       estimated using eigengap heuristic
%   Output:
%       K: number of clusters
%       grps: the assigned labels
%% . 
    
    % generate affinity matrix
    N = size(CMat,1);
    [~,Ind] = sort( CMat, 1, 'descend');
    for i=1:N
        CMat(:,i) = CMat(:,i) ./ (CMat(Ind(1,i),i)+eps);
    end
    CSym = 0.5*(CMat + CMat');
    
    % perform spectral clustering on the affinity matrix
    if nargin < 2
        [K,grps] = SpectralClustering(CSym);
    else
        [K,grps] = SpectralClustering(CSym, K);
    end
end