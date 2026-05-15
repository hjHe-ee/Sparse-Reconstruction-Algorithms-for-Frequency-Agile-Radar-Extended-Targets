clear; clc; close all;

rng(1,"twister")

par = radarParams();
SNRdB = 30;

[PhiCell, Yclean, xTrue, axesInfo] = simulateScene(par);
Y = addNoiseBySNR(Yclean, SNRdB);

opts = algorithmOptions();

results = runFourAlgorithms(PhiCell, Y, opts);

figure('Name', 'Four Algorithms Reconstruction Results');
tiledlayout(4, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

names = {'RAMP', 'ADMM', 'MFOCUSS', 'ADMM-MFOCUSS'};
Xs = {results.RAMP, results.ADMM, results.MFOCUSS, results.ADMM_MFOCUSS};

for i = 1:4
    ampMap = sparseVecToMap(Xs{i}, par);

    nexttile;
    surf(axesInfo.rangeAxis, axesInfo.velocityAxis, ampMap.', 'EdgeColor', 'none');
    xlabel('距离/m');
    ylabel('速度/(m/s)');
    zlabel('幅度');
    title([names{i}, ' 3D']);
    view(45, 35);
    grid on;

    nexttile;
    imagesc(axesInfo.rangeAxis, axesInfo.velocityAxis, ampMap.');
    axis xy;
    xlabel('距离/m');
    ylabel('速度/(m/s)');
    title([names{i}, ' 2D']);
    colorbar;
    hold on;
    plot(par.targetRanges, par.targetVelocities, 'ro', 'LineWidth', 1.2, 'MarkerSize', 7);
end