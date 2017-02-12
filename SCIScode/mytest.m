% 可视化SM核 
% A = 3;
% wa = rand(A, 1);
% v = rand(A, 1);
% m = rand(A, 1);
% 
% d = rand(100000, 1);
% y = exp(-2*pi*pi*(d.*d)*v') .* cos(2*pi*d*m')* wa;
% 
% figure;
% plot(d, y, '.');

% 只用时间特征，用SM核学习周期性！！！！！！！！！！！！！！！！！！
clear all, close all;
rand('seed', 7);
data = importdata('data_norm.mat');
pm25_max = importdata('pm25_max.mat');
pm25_mean = importdata('pm25_mean.mat');
pm25_min = importdata('pm25_min.mat');

x = data(1000:1500, 2);
y = data(1000:1500, 1);
z = data(1750:2000, 2);
ground = data(1750:2000, 1);
ground = (ground+pm25_mean)*(pm25_max-pm25_min)+pm25_min;
ground_self = (y+pm25_mean)*(pm25_max-pm25_min)+pm25_min;
% x = 1:500;
% y = cos(x);
% z = 600:1000;



Q =5;
likfunc = @likGauss;
covfunc = {@covSM, Q};
%hyp.cov = initSMhypers(Q, x, y);
%hyp.cov(hyp.cov==inf) = 0;
hyp.cov = rand(1, 3*Q);
hyp.cov
hyp.lik = log(0.1);
hyp = minimize(hyp, @gp, -1000, @infExact, [], covfunc, likfunc, x, y);

[m, s2] = gp(hyp, @infExact, [], covfunc, likfunc, x, y, z);
m = (m+pm25_mean)*(pm25_max-pm25_min)+pm25_min;

[m_self, ~] = gp(hyp, @infExact, [], covfunc, likfunc, x, y, x);
m_self = (m_self+pm25_mean)*(pm25_max-pm25_min)+pm25_min;
figure;
plot(1:length(m_self), ground_self, 'b-');
hold on
plot(1:length(m_self), m_self, 'r.');

