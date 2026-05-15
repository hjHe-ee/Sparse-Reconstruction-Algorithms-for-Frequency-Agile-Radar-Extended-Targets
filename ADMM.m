function x = ADMM(Phi, y, opts)
% ADMM for LASSO:
% min_x 0.5*||y - Phi*x||_2^2 + lambda*||x||_1

if nargin < 3, opts = struct(); end
lambda  = getOpt(opts, 'lambda', 0.08);
rho     = getOpt(opts, 'rho', 1.0);
maxIter = getOpt(opts, 'maxIter', 120);
tol     = getOpt(opts, 'tol', 1e-5);

[~, N] = size(Phi);

x = zeros(N, 1);
z = zeros(N, 1);
u = zeros(N, 1);

A = Phi' * Phi + rho * eye(N);
b0 = Phi' * y;

for k = 1:maxIter
    xOld = x;
    zOld = z;

    x = A \ (b0 + rho * (z - u));
    z = softThresholdComplex(x + u, lambda / rho);
    u = u + x - z;

    primalRes = norm(x - z);
    dualRes = rho * norm(z - zOld);

    if primalRes < tol && dualRes < tol
        break;
    end

    if norm(x - xOld) / max(norm(xOld), eps) < tol
        break;
    end
end

x = z;
end

function z = softThresholdComplex(x, th)
z = max(abs(x) - th, 0) ./ max(abs(x), eps) .* x;
end

function v = getOpt(s, name, default)
if isfield(s, name), v = s.(name); else, v = default; end
end