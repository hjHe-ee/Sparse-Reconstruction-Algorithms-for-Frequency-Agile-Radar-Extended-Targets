function xTrue = makeTruthVector(par)

NperGate = par.P * par.Q;
xTrue = zeros(NperGate, par.NA);

vGrid = linspace(par.vMin, par.vMax, par.Q);

for k = 1:numel(par.targetAmps)
    r0 = par.targetRanges(k);
    v0 = par.targetVelocities(k);
    a0 = par.targetAmps(k);

    na = floor((r0 - par.rangeStart) / par.coarseDr) + 1;
    na = min(max(na, 1), par.NA);

    rGateStart = par.rangeStart + (na - 1) * par.coarseDr;
    p = round((r0 - rGateStart) / par.dr) + 1;
    p = min(max(p, 1), par.P);

    [~, q] = min(abs(vGrid - v0));

    idx = sub2ind([par.P, par.Q], p, q);
    xTrue(idx, na) = xTrue(idx, na) + a0;
end

xTrue = xTrue(:);
end