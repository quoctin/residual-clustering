function [label, mu, energy] = kmeans(X, m)
% Perform kmeans clustering.
% Input:
%   X: d x n data matrix
%   m: initialization parameter
% Output:
%   label: 1 x n sample labels
%   mu: d x k center of clusters
%   energy: optimization target value
% Written by Mo Chen (sth4nth@gmail.com).
label = init(X, m);
n = numel(label);
idx = 1:n;
last = zeros(1,n);
MAX_ITER =10000;
iter = 1;
while any(label ~= last)
    [~,~,last(:)] = unique(label);                  % remove empty clusters
    mu = X*normalize(sparse(idx,last,1),1);         % compute cluster centers 
    [val,label] = min(bsxfun(@minus,dot(mu,mu,1)'/2,mu')*X,[],1);  % assign sample labels
    iter = iter + 1;
    if iter > MAX_ITER
        break;
    end
end
energy = dot(X(:),X(:),1)+2*sum(val);

function label = init(X, m)
[d,n] = size(X);
if numel(m) == 1                           % random initialization
    mu = X(:,randperm(n,m));
    [~,label] = min(dot(mu,mu,1)'/2-mu'*X,[],1); 
elseif all(size(m) == [1,n])               % init with labels
    label = m;
elseif size(m,1) == d                      % init with seeds (centers)
    [~,label] = min(bsxfun(@minus,dot(m,m,1)'/2, m')*X,[],1); 
end

