function Phi = makeDictionary(par, rGateStart, rGateCenter)

rGrid = rGateStart + (0:par.P-1).' * par.dr;
vGrid = linspace(par.vMin, par.vMax, par.Q);

[RR, VV] = ndgrid(rGrid, vGrid);

rVec = RR(:);
vVec = VV(:);

N = numel(rVec);
Phi = zeros(par.M, N);

mVec = (0:par.M-1).';
fVec = par.f0 + par.dm(:) * par.Df;
tGate = 2 * rGateCenter / par.c;

for n = 1:N
    tau = 2 * (rVec(n) - vVec(n) * mVec * par.Tr) / par.c;
    envelope = sinc(par.B * (tGate - tau));
    phase = exp(-1j * 2 * pi * fVec .* tau);

    col = envelope .* phase;
    Phi(:, n) = col / max(norm(col), eps);
end
end