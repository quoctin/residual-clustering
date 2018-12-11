%--------------------------------------------------------------------------
% Copyright @ Quoc-Tin Phan, 2018-2020
%--------------------------------------------------------------------------

function [K, grps] = SpectralClustering(CSym, K)
%%  This function performs spectral clustering on the affinity matrix
%   Input:
%       CSym: nxn affinity matrix
%       K (optional): the number of clusters. If K isn't given, it is
%       estimated using eigengap heuristic
%   Output: 
%       K: number of clusters
%       grps: the assigned labels
%% . 
    
    N = size(CSym,1);
    % normalized Laplacian matrix
    DN = diag(1./sqrt(sum(CSym)+eps));
    LapN = speye(N) - DN * CSym * DN; 
    [V,D] = eig(LapN, 'nobalance');
    eigval = diag(D);
    [srt_eigval, srt_ind] = sort(eigval, 'descend');
    V = V(:, srt_ind);
    if nargin < 2
        % Estimating K based on eigengap heuristic
        [~, ind] = max(abs(srt_eigval(1:end-2) - srt_eigval(2:end-1)));     
        K = N - ind;
    end
    % Partition data points
    kerN = V(:,N-K+1:N);
    kerNS = zeros(size(kerN));
    for i = 1:N
        kerNS(i,:) = kerN(i,:) ./ norm(kerN(i,:)+eps);
    end
    rng(1); % for reproducibility
    grps = kmeans_fast(kerNS', kseeds(kerNS', K))';
end
