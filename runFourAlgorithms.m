function results = runFourAlgorithms(PhiCell, Y, opts)

NA = numel(PhiCell);
N = size(PhiCell{1}, 2);

XRAMP = zeros(N, NA);
XADMM = zeros(N, NA);
XMFOCUSS = zeros(N, NA);

for na = 1:NA
    XRAMP(:, na) = RAMP(PhiCell{na}, Y(:, na), opts.ramp);
    XADMM(:, na) = ADMM(PhiCell{na}, Y(:, na), opts.admm);
    XMFOCUSS(:, na) = MFOCUSS(PhiCell{na}, Y(:, na), opts.mfocuss);
end

XADMM_MFOCUSS = ADMM_MFOCUSS(PhiCell, Y, opts.admm_mfocuss);

results.RAMP = XRAMP(:);
results.ADMM = XADMM(:);
results.MFOCUSS = XMFOCUSS(:);
results.ADMM_MFOCUSS = XADMM_MFOCUSS(:);
end