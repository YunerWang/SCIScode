% 使用Z-score标准化方法 归一化数据
clear;
clc;

% nxd 的矩阵
% data = xlsread('dataForSDM.xlsx');
% 
% mean_vec = mean(data);
% std_vec = std(data);
% 
% [row, ~] = size(data);
% mean_mat = repmat(mean_vec, row, 1);
% std_mat = repmat(std_vec, row, 1);
% 
% % 构造归一化数据集
% data_norm = (data-mean_mat)./std_mat;
% save data_norm data_norm;
% 
% pm25_mean = mean_vec(1);
% pm25_std = std_vec(1);
% save pm25_mean pm25_mean;
% save pm25_std pm25_std;
% 
% t_mean = mean_vec(2);
% t_std = std_vec(2);
% save t_mean t_mean;
% save t_std t_std;
% 
% jingdu_mean = mean_vec(3);
% jingdu_std = std_vec(3);
% save jingdu_mean jingdu_mean;
% save jingdu_std jingdu_std;
% 
% weidu_mean = mean_vec(4);
% weidu_std = std_vec(4);
% save weidu_mean weidu_mean;
% save weidu_std weidu_std;

% 可视化结果
% load('data.mat');
% load('data_norm.mat');
% figure;
% set(gcf,'color','white','paperpositionmode','auto');
% % subplot(2, 1, 1);
% plot(data(:, end-2), data_norm(:, 1), '.');

% set(gcf,'color','white','paperpositionmode','auto');
% plot(data(:, 2)*30/3600, data(:, 1), '.');



