function par = radarParams()

par.c = 3e8;

par.Tr = 100e-6;
par.Tp = 10e-6;
par.B = 10e6;
par.Df = 10e6;
par.fs = 10e6;

par.M = 32;
par.P = 32;
par.Q = 32;
par.NA = 3;

par.f0 = 10e9;

par.dm = randperm(par.M) - 1;

par.dr = par.c / (2 * par.M * par.Df);
par.coarseDr = par.c / (2 * par.Df);

par.rangeStart = 7675;
par.vMin = -75;
par.vMax = 75;

par.targetAmps = ones(3, 1);
par.targetRanges = [7698.8; 7702.8; 7706.3];
par.targetVelocities = [-18.98; -11.46; -26.40];
end