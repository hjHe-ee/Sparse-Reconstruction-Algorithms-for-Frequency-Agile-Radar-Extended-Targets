function [PhiCell, Yclean, xTrue, axesInfo] = simulateScene(par)

PhiCell = cell(par.NA, 1);
Yclean = zeros(par.M, par.NA);

mVec = (0:par.M-1).';
fVec = par.f0 + par.dm(:) * par.Df;

for na = 1:par.NA
    rGateStart = par.rangeStart + (na - 1) * par.coarseDr;
    rGateCenter = rGateStart + par.coarseDr / 2;
    tGate = 2 * rGateCenter / par.c;

    PhiCell{na} = makeDictionary(par, rGateStart, rGateCenter);

    y = zeros(par.M, 1);

    for k = 1:numel(par.targetAmps)
        r0 = par.targetRanges(k);
        v0 = par.targetVelocities(k);
        a0 = par.targetAmps(k);

        tau = 2 * (r0 - v0 * mVec * par.Tr) / par.c;
        envelope = sinc(par.B * (tGate - tau));
        phase = exp(-1j * 2 * pi * fVec .* tau);

        y = y + a0 * envelope .* phase;
    end

    Yclean(:, na) = y;
end

xTrue = makeTruthVector(par);

rangeAxis = zeros(par.NA * par.P, 1);
for na = 1:par.NA
    rGateStart = par.rangeStart + (na - 1) * par.coarseDr;
    idx = (na - 1) * par.P + (1:par.P);
    rangeAxis(idx) = rGateStart + (0:par.P-1).' * par.dr;
end

axesInfo.rangeAxis = rangeAxis;
axesInfo.velocityAxis = linspace(par.vMin, par.vMax, par.Q);
end