function opts = algorithmOptions()

opts.ramp.maxIter = 40;
opts.ramp.step = 2;
opts.ramp.tol = 1e-5;

opts.admm.lambda = 0.08;
opts.admm.rho = 1.0;
opts.admm.maxIter = 120;
opts.admm.tol = 1e-5;

opts.mfocuss.p = 0.8;
opts.mfocuss.lambda = 1e-3;
opts.mfocuss.maxIter = 60;
opts.mfocuss.tol = 1e-5;

opts.admm_mfocuss.eta = 0.90;
opts.admm_mfocuss.admmOpts = opts.admm;
opts.admm_mfocuss.mfocussOpts = opts.mfocuss;
end