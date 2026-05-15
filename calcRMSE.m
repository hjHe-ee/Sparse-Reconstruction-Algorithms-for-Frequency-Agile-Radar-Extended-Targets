function e = calcRMSE(xHat, xTrue)

xh = abs(xHat(:));
xt = abs(xTrue(:));

if max(xh) > 0
    xh = xh / max(xh);
end

if max(xt) > 0
    xt = xt / max(xt);
end

e = sqrt(mean((xh - xt).^2));
end