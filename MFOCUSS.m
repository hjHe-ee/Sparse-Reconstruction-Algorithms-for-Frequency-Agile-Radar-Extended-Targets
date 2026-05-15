function x = MFOCUSS(Phi, y, opts)
% Multi Focal Underdetermined System Solver

if nargin < 3, opts = struct(); end
p       = getOpt(opts, 'p', 0.8);
lambda  = getOpt(opts, 'lambda', 1e-3);
maxIter = getOpt(opts, 'maxIter', 60);
tol     = getOpt(opts, 'tol', 1e-5);
x0      = getOpt(opts, 'x0', []);

[M, N] = size(Phi);

if isempty(x0)
    x = Phi' * ((Phi * Phi' + lambda * eye(M)) \ y);
else
    x = x0(:);
    if numel(x) ~= N
        error('opts.x0 length must equal size(Phi,2).');
    end
end

for k = 1:maxIter
    xOld = x;

    w = (abs(xOld) + eps) .^ (1 - p / 2);
    PhiW = Phi .* reshape(w, 1, []);

    x = w(:) .* (PhiW' * ((PhiW * PhiW' + lambda * eye(M)) \ y));

    if norm(x - xOld) / max(norm(xOld), eps) < tol
        break;
    end
end
end

function v = getOpt(s, name, default)
if isfield(s, name), v = s.(name); else, v = default; end
end