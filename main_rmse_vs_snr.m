clear; clc; close all;

rng(1,"twister")

par = radarParams();
opts = algorithmOptions();

SNRs = 0:5:30;
MC = 1;100;

rmseRAMP = zeros(size(SNRs));
rmseADMM = zeros(size(SNRs));
rmseMFOCUSS = zeros(size(SNRs));
rmseADMM_MFOCUSS = zeros(size(SNRs));

[PhiCell, Yclean, xTrue] = simulateScene(par);

for is = 1:numel(SNRs)
    snr = SNRs(is);

    tmpR = zeros(MC, 1);
    tmpA = zeros(MC, 1);
    tmpM = zeros(MC, 1);
    tmpAM = zeros(MC, 1);

    for mc = 1:MC
        Y = addNoiseBySNR(Yclean, snr);
        results = runFourAlgorithms(PhiCell, Y, opts);

        tmpR(mc)  = calcRMSE(results.RAMP, xTrue);
        tmpA(mc)  = calcRMSE(results.ADMM, xTrue);
        tmpM(mc)  = calcRMSE(results.MFOCUSS, xTrue);
        tmpAM(mc) = calcRMSE(results.ADMM_MFOCUSS, xTrue);
    end

    rmseRAMP(is) = mean(tmpR);
    rmseADMM(is) = mean(tmpA);
    rmseMFOCUSS(is) = mean(tmpM);
    rmseADMM_MFOCUSS(is) = mean(tmpAM);

    fprintf('SNR = %2d dB finished.\n', snr);
end

figure('Name', 'RMSE vs SNR');
plot(SNRs, rmseRAMP, '-o', 'LineWidth', 1.4); hold on;
plot(SNRs, rmseADMM, '-s', 'LineWidth', 1.4);
plot(SNRs, rmseMFOCUSS, '-^', 'LineWidth', 1.4);
plot(SNRs, rmseADMM_MFOCUSS, '-d', 'LineWidth', 1.4);
grid on;
xlabel('信噪比/dB');
ylabel('RMSE');
legend('RAMP', 'ADMM', 'MFOCUSS', 'ADMM-MFOCUSS', 'Location', 'northeast');
title('不同算法的RMSE随SNR变化曲线');