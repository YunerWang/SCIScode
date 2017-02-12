clear all, close all;
rand('seed', 7);
data = importdata('data_norm.mat');
pm25_max = importdata('pm25_max.mat');
pm25_mean = importdata('pm25_mean.mat');
pm25_min = importdata('pm25_min.mat');

x = data(1000:1500, 2:end);
y = data(1000:1500, 1);
z = data(1501:1700, 2:end);
ground = data(1501:1700, 1);
ground = (ground+pm25_mean)*(pm25_max-pm25_min)+pm25_min;

Q = 5;
likfunc = @likGauss;
covfunc = {@covSDM, Q};
hyp.cov = rand(1, 3*Q+2*(size(x, 2)-2)); 
%hyp.cov = rand(1, Q+2*Q*8); 
hyp.lik = log(0.1);
hyp = minimize(hyp, @gp, -400, @infExact, [], covfunc, likfunc, x, y);

[m s2] = gp(hyp, @infExact, [], covfunc, likfunc, x, y, z);
m = (m+pm25_mean)*(pm25_max-pm25_min)+pm25_min;

mae = mean(abs(m-ground)./ground);
disp(['the mae = ' num2str(mae)]);