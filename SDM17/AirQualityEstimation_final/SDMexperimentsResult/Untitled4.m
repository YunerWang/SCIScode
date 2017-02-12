clear;clc;

% rmse = importdata('rmse.mat');
rmse = importdata('traint.mat');
rmse = rmse(:, 1:end-1);
lwidth = 3.5;
x = 1:8;
figure;
plot(x, rmse(1, :), 'r*-', 'linewidth', lwidth);
hold on;
plot(x(1:4), rmse(2, 1:4), 'b^-', 'linewidth', lwidth);

plot(x(1:4), rmse(3, 1:4), 'k+-', 'linewidth', lwidth);

plot(x(1:9), rmse(4, 1:9), 'yv-', 'linewidth', lwidth);

% plot(x(1:9), rmse(5, 1:9), 'gd-', 'linewidth', lwidth);
