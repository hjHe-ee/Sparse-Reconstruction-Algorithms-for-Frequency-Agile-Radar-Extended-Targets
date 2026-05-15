function Xout = ADMM_MFOCUSS(PhiCell, Y, opts)
% ADMM-MFOCUSS for multi-range-bin extended target reconstruction
%
% PhiCell{na}: M x N dictionary of range gate na
% Y(:,na):     M x 1 observation of range gate na
% Xout:        N x NA sparse result matrix

if nargin < 3, opts = struct(); end

eta = getOpt(opts, 'eta', 0.90);

admmOpts = getOpt(opts, 'admmOpts', struct());
mfOpts   = getOpt(opts, 'mfocussOpts', struct());

NA = numel(PhiCell);
N = size(PhiCell{1}, 2);

Xadmm = zeros(N, NA);

for na = 1:NA
    Xadmm(:, na) = ADMM(PhiCell{na}, Y(:, na), admmOpts);
end

% suppress duplicate reconstruction across adjacent range bins
Xprocessed = zeros(N, NA);
[~, maxBin] = max(abs(Xadmm), [], 2);

for n = 1:N
    b = maxBin(n);
    Xprocessed(n, b) = Xadmm(n, b);
end

Xout = zeros(N, NA);

for na = 1:NA
    xp = Xprocessed(:, na);
    energy = abs(xp).^2;

    if sum(energy) <= eps
        continue;
    end

    [energySort, idxSort] = sort(energy, 'descend');
    ratio = cumsum(energySort) / sum(energySort);

    K = find(ratio >= eta, 1, 'first');
    support = idxSort(1:K);
    support = support(abs(xp(support)) > 0);

    if isempty(support)
        continue;
    end

    PhiS = PhiCell{na}(:, support);

    mfLocal = mfOpts;
    mfLocal.x0 = xp(support);

    xS = MFOCUSS(PhiS, Y(:, na), mfLocal);

    xTmp = zeros(N, 1);
    xTmp(support) = xS;
    Xout(:, na) = xTmp;
end
end

function v = getOpt(s, name, default)
if isfield(s, name), v = s.(name); else, v = default; end
end