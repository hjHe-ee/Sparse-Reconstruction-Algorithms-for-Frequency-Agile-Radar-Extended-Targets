function x = RAMP(Phi, y, opts)
% Regularized Adaptive Matching Pursuit
% x = RAMP(Phi, y, opts)

if nargin < 3, opts = struct(); end
maxIter = getOpt(opts, 'maxIter', 40);
step    = getOpt(opts, 'step', 2);
tol     = getOpt(opts, 'tol', 1e-5);

[M, N] = size(Phi);
x = zeros(N, 1);
r = y;
support = [];
lastNorm = norm(r);

for it = 1:maxIter
    u = abs(Phi' * r);
    [~, idxSort] = sort(u, 'descend');

    L = min(it * step, N);
    cand = unique([support(:); idxSort(1:L)]);

    mag = u(cand);
    th = mean(mag);
    cand = cand(mag >= th);

    supportNew = unique([support(:); cand(:)]);

    xs = zeros(length(supportNew), 1);
    if ~isempty(supportNew)
        xs = Phi(:, supportNew) \ y;
    end

    rNew = y - Phi(:, supportNew) * xs;
    newNorm = norm(rNew);

    if newNorm < lastNorm
        support = supportNew;
        r = rNew;
        lastNorm = newNorm;
    else
        break;
    end

    if norm(r) / max(norm(y), eps) < tol
        break;
    end
end

if ~isempty(support)
    x(support) = Phi(:, support) \ y;
end
end

function v = getOpt(s, name, default)
if isfield(s, name), v = s.(name); else, v = default; end
end