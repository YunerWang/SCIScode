clear all, close all;
rand('seed', 7);
meanfunc = {@meanSum, {@meanLinear, @meanConst}}; hyp.mean=[0;0;0;0;0;0;0;0;0];
covfunc = {@covMaterniso, 3}; ell = 1/4; sf = 1; hyp.cov = log([ell;sf]);
likfunc = @likGauss; sn = 0.1; hyp.lik = log(sn);

data = importdata('data_norm.mat');
pm25_max = importdata('pm25_max.mat');
pm25_mean = importdata('pm25_mean.mat');
pm25_min = importdata('pm25_min.mat');

x = data(1:9:300, 2:end);
y = data(1:9:300, 1);

% plot(1:1000, y, '+');

z = data(1000:1500, 2:end);
ground = data(1000:1500, 1);
ground = (ground+pm25_mean)*(pm25_max-pm25_min)+pm25_min;

% 在数据量少的情况下使用精确推断
% 预设参数
% nlml = gp(hyp, @infExact, meanfunc, covfunc, likfunc, x, y);

% [m, s2] = gp(hyp, @infExact, meanfunc, covfunc, likfunc, x, y, z);

% 最优化参数 
covfunc = @covSEiso; 
% covfunc = {'covProd', {'covRQiso', 'covSEard', 'covNoise'}};
hyp2.cov=log(rand(1, 2)); hyp2.lik=log(0.1);hyp2.mean = [0;0;0;0;0;0;0;0;0];
hyp2 = minimize(hyp2, @gp, -200, @infExact, meanfunc, covfunc, likfunc, x, y);
% hyp2 = minimize(hyp2, @gp, -1000, @infEP, meanfunc, covfunc, likfunc, x, y);

[m s2] = gp(hyp2, @infExact, meanfunc, covfunc, likfunc, x, y, z);
% kss = covfunc(hyp2.cov, x, z); % 求train_test
% kss = feval(covfunc{:}, hyp2.cov, x, z);
m = (m+pm25_mean)*(pm25_max-pm25_min)+pm25_min;

% 非精确推断

mae = mean(abs(m-ground))

plot(1:501, m, 'r');
hold on;
plot(1:501, ground, 'b');

