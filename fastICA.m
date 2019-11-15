function [Zica, W, T, mu] = fastICA(Z,r,type,flag)

TOL = 1e-6;         % Convergence criteria
MAX_ITERS = 100;    % Max # iterations

if ~exist('type','var') || isempty(type)
    % Default type
    type = 'kurtosis';
end
n = size(Z,2);

% Set type
if strncmpi(type,'kurtosis',1)
    % Kurtosis
    USE_KURTOSIS = true;
    algoStr = 'kurtosis';
elseif strncmpi(type,'negentropy',1)
    % Negentropy
    USE_KURTOSIS = false;
    algoStr = 'negentropy';
end

[Zc, mu] = centerRows(Z);
[Zcw, T] = whitenRows(Zc);

normRows = @(X) bsxfun(@rdivide,X,sqrt(sum(X.^2,2)));

W = normRows(rand(r,size(Z,1))); % Random initial weights
k = 0;
delta = inf;
while delta > TOL && k < MAX_ITERS
    k = k + 1;
    
    Wlast = W; % Save last weights
    Sk = W * Zcw;
    if USE_KURTOSIS
        % Kurtosis
        G = 4 * Sk.^3;
        Gp = 12 * Sk.^2;
    else
        % Negentropy
        G = Sk .* exp(-0.5 * Sk.^2);
        Gp = (1 - Sk.^2) .* exp(-0.5 * Sk.^2);
    end
    W = (G * Zcw') / n - bsxfun(@times,mean(Gp,2),W);
    W = normRows(W);
    
    % Decorrelate weights
    [U, S, ~] = svd(W,'econ');
    W = U * diag(1 ./ diag(S)) * U' * W;
    
    % Update convergence criteria
    delta = max(1 - abs(dot(W,Wlast,2)));
    if flag
        fprintf(str,k,k,k - 1,delta);
    end
end
if flag
    fprintf('\n');
end

% Independent components
Zica = W * Zcw;
