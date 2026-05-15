function ampMap = sparseVecToMap(x, par)

NperGate = par.P * par.Q;
X = reshape(x, NperGate, par.NA);

ampMap = zeros(par.NA * par.P, par.Q);

for na = 1:par.NA
    xGate = reshape(abs(X(:, na)), par.P, par.Q);
    idx = (na - 1) * par.P + (1:par.P);
    ampMap(idx, :) = xGate;
end

mx = max(ampMap(:));
if mx > 0
    ampMap = ampMap / mx;
end
end