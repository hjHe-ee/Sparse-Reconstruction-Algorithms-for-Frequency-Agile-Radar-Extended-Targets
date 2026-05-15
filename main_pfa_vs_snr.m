clear; clc; close all;

rng(1,"twister")

par = radarParams();
opts = algorithmOptions();

SNRs = 0:5:30;
MC = 1;100;
threshold = 0.1;

pfaRAMP = zeros(size(SNRs));
pfaADMM = zeros(size(SNRs));
pfaMFOCUSS = zeros(size(SNRs));
pfaADMM_MFOCUSS = zeros(size(SNRs));

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

        tmpR(mc)  = calcPFA(results.RAMP, xTrue, threshold);
        tmpA(mc)  = calcPFA(results.ADMM, xTrue, threshold);
        tmpM(mc)  = calcPFA(results.MFOCUSS, xTrue, threshold);
        tmpAM(mc) = calcPFA(results.ADMM_MFOCUSS, xTrue, threshold);
    end

    pfaRAMP(is) = mean(tmpR);
    pfaADMM(is) = mean(tmpA);
    pfaMFOCUSS(is) = mean(tmpM);
    pfaADMM_MFOCUSS(is) = mean(tmpAM);

    fprintf('SNR = %2d dB finished.\n', snr);
end

figure('Name', 'False Alarm Rate vs SNR');
plot(SNRs, pfaRAMP, '-o', 'LineWidth', 1.4); hold on;
plot(SNRs, pfaADMM, '-s', 'LineWidth', 1.4);
plot(SNRs, pfaMFOCUSS, '-^', 'LineWidth', 1.4);
plot(SNRs, pfaADMM_MFOCUSS, '-d', 'LineWidth', 1.4);
grid on;
xlabel('信噪比/dB');
ylabel('P_{FA}');
legend('RAMP', 'ADMM', 'MFOCUSS', 'ADMM-MFOCUSS', 'Location', 'northeast');
title('不同算法的虚警率随SNR变化曲线');