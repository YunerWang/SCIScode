% 一共取128000条数据，共四天，32000条/天，
% 稀疏规则：每天取10000条

clear;clc;
close all;

load data_norm;


fir = 96000;
rand_idx = fir + randperm(5000);
sub_idx = sort(rand_idx(1:500));
data4_norm = data_norm(sub_idx, :);
figure;
subplot(1, 2, 1);
plot(data_norm(rand_idx, 3), data_norm(rand_idx, 4), 'b.');
hold on;
plot(data4_norm(:, 3), data4_norm(:, 4), 'r.');
hold off;

subplot(1, 2, 2);
plot(1:32000, data_norm(sort(rand_idx), 2),  'b.');
hold on;
plot(1:10000, data4_norm(:, 2),  'r.');
title('time');
hold off;

save data4_norm data4_norm; 
