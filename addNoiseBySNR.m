function Y = addNoiseBySNR(Yclean, SNRdB)

signalPower = mean(abs(Yclean(:)).^2);
noisePower = signalPower / (10^(SNRdB / 10));

noise = sqrt(noisePower / 2) * ...
    (randn(size(Yclean)) + 1j * randn(size(Yclean)));

Y = Yclean + noise;
end