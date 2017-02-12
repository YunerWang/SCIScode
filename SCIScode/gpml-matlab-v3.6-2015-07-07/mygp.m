clear all, close all

meanfunc = {@meanSum, {@meanLinear, @meanConst}};
% covfunc = {@covMaterniso, 3}; ell = 1/4; sf = 1; hyp.cov = log([ell; sf]);
likfunc = @likGauss; % sn = 0.1; hyp.lik = log(sn);

data = importdata('data_norm.mat');
pm25_max = importdata('pm25_max.mat');
pm25_mean = importdata('pm25_mean.mat');
pm25_min = importdata('pm25_min.mat');


x = data(1:1000, 2:end);
y = data(1:1000, 1);
z = data(1500:2000, 2:end);
ground = data(1500:2000, 1);
ground = (ground+pm25_mean)*(pm25_max-pm25_min)+pm25_min;
% n = 20;
% x = gpml_randn(0.3, n, 1);
% K = feval(covfunc{:}, hyp.cov, x);
% mu = feval(meanfunc{:}, hyp.mean, x);
% y = chol(K)'*gpml_randn(0.15, n, 1) + mu + exp(hyp.lik)*gpml_randn(0.2, n, 1);
% z = linspace(-1.9, 1.9, 101)';

covfunc = @covSEiso; hyp2.cov = [0;0]; hyp2.lik = log(0.1);% hyp2.mean = [0.5;1];
hyp2 = minimize(hyp2, @gp, -100, @infFITC, [], covfunc, likfunc, x, y);
exp(hyp2.lik)
% nlml2 = gp(hyp2, @infExact, [], covfunc, likfunc, x, y);

[m s2] = gp(hyp2, @infFITC, [], covfunc, likfunc, x, y, z);
m = (m+pm25_mean)*(pm25_max-pm25_min)+pm25_min;

mae = mean(abs(m-ground));
disp(['the mae = ' num2str(mae)]);
% f = [m+2*sqrt(s2); flipdim(m-2*sqrt(s2), 1)];
% fill([z; flipdim(z, 1)], f, [7 7 7]/8)
hold on; 
input_x = 1:size(ground);
plot(input_x, m, 'r-');
plot(input_x, ground, 'b-');
% plot(x, y, '+');
