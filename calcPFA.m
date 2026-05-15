function pfa = calcPFA(xHat, xTrue, threshold)

xh = abs(xHat(:));
xt = abs(xTrue(:));

if max(xh) > 0
    xh = xh / max(xh);
end

trueMask = xt > 0;
detectMask = xh > threshold;

falseAlarm = detectMask & ~trueMask;

pfa = sum(falseAlarm) / numel(xh);
end