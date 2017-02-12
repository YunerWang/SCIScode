clear;clc;
% nxd 的矩阵
data = xlsread('dataForSDM.xlsx');

max_vec = max(data);
min_vec = min(data);

pm25_max = max_vec(1);
pm25_min = min_vec(1);
t_max = max_vec(2);
t_min = min_vec(2);
jingdu_max = max_vec(3);
jingdu_min = min_vec(3);
weidu_max = max_vec(4);
weidu_min = min_vec(4);

% save pm25_max pm25_max;
% save pm25_min pm25_min;
% save t_max t_max;
% save t_min t_min;
save jingdu_max jingdu_max;
save jingdu_min jingdu_min;
save weidu_max weidu_max;
save weidu_min weidu_min;


[row, ~] = size(data);
max_mat = repmat(max_vec, row, 1);
min_mat = repmat(min_vec, row, 1);

% 构造归一化数据集
data_norm = (data-min_mat)./(max_mat-min_mat);

data_norm_mean = repmat(mean(data_norm), row, 1);

% pm25_mean = data_norm_mean(1, 1);
% % save pm25_mean pm25_mean;
% t_mean = data_norm_mean(1, 2);
% save t_mean t_mean;

jingdu_mean = data_norm_mean(1, 3);
save jingdu_mean jingdu_mean;
weidu_mean = data_norm_mean(1, 4);
save weidu_mean weidu_mean;

% 构造均值为0的数据集
% data_norm = data_norm-data_norm_mean;
% 
% save data_norm data_norm;