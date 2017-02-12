% 基于lab1的数据集trainingSet和nodes_cell, （10000个samples的划分结果）
% 进行频率分析
clear;clc;
close all;
load trainingSet;
load nodeset_cell;
load t_mean;
load t_std;
load pm25_mean;
load pm25_std;
data = importdata('data_norm.mat');
rand('seed', 7);
% 展示一下nodes_cell的经纬度分布
% figure;
% plot(trainingSet(:, 3), trainingSet(:, 4), 'b.');
% title('总数据分布');
% hold on;

%     d = trainingSet(1:10:10000, :);
%     % the size of d
%     n_d = size(d, 1);
%     train_size = ceil(n_d*2/3);
%     test_size = n_d-train_size;
%     d_train = d(1:train_size, :);
%     d_test = d(train_size+1:end, :);
%     y_ground_train = d_train(:, 1)*pm25_std+pm25_mean; 
%     y_ground_test = d_test(:, 1)*pm25_std+pm25_mean;
% 
%     meanfunc = {@meanSum, {@meanLinear, @meanConst}};
%     %hyp.mean = [0;0];
%     Q = 3;
%     covfunc = {@covSDM_noise, Q};
%     hyp.cov = log(rand(1, 3*Q+2*(size(d_train, 2)-3)+1));
% %     covfunc = @covSEiso;
% %     hyp.cov = log(rand(1, 2));
%     likfunc = @likGauss;
%     hyp.lik = log(0.1);
%     
%     hyp = minimize(hyp, @gp, -200, @infExact, [], covfunc, likfunc, d_train(:, 2:end), d_train(:, 1));
%     
%     % 展示训练效果
%     [m_train, s_train] = gp(hyp, @infExact, [], covfunc, likfunc, d_train(:, 2:end), d_train(:, 1), d_train(:, 2:end));
%     m_train = m_train(:, 1)*pm25_std+pm25_mean;
%     figure;
%     plot(1:length(m_train), m_train, 'r-');
%     hold on;
%     plot(1:length(m_train), y_ground_train, 'b.');
%     rmse_tr = sqrt(sum((m_train-y_ground_train).*(m_train-y_ground_train))/length(m_train));
%     title(['train : ' num2str(rmse_tr)]);
%     
%     % 展示预测效果
%     [m_test, s_test] = gp(hyp, @infExact, [], covfunc, likfunc, d_train(:, 2:end), d_train(:, 1), d_test(:, 2:end));
%     m_test = m_test(:, 1)*pm25_std+pm25_mean;
%     figure;
%     plot(1:length(m_test), m_test, 'r-');
%     hold on;
%     plot(1:length(m_test), y_ground_test, 'b.');
%     rmse_ts = sqrt(sum((m_test-y_ground_test).*(m_test-y_ground_test))/length(m_test));
%     title(['test : ' num2str(rmse_ts)]);
n = size(nodeset_cell, 2);
RMSE_tr = zeros(1, n);
RMSE_ts = zeros(1, n);
for i = 1:n
    d = trainingSet(nodeset_cell{i}.recordnum, :);
    % the size of d
    n_d = size(d, 1);
    train_size = ceil(n_d*2/3);
    test_size = n_d-train_size;
    d_train = d(1:train_size, :);
    d_test = d(train_size+1:end, :);
    y_ground_train = d_train(:, 1)*pm25_std+pm25_mean; 
    y_ground_test = d_test(:, 1)*pm25_std+pm25_mean;

    meanfunc = {@meanSum, {@meanLinear, @meanConst}};
    %hyp.mean = [0;0];
    Q = 1;
    D = 8;
%     covfunc = {@covSM, Q}; % SM核的参数为(1+2D)*Q
%     hyp.cov = log(rand(1, (1+2*D)*Q));
    covfunc = @covSEiso;
    hyp.cov = log(rand(1, 2));
    likfunc = @likGauss;
    hyp.lik = log(0.1);
    
    hyp = minimize(hyp, @gp, -20, @infExact, [], covfunc, likfunc, d_train(:, 2:end), d_train(:, 1));
    
    % 展示训练效果
    [m_train, s_train] = gp(hyp, @infExact, [], covfunc, likfunc, d_train(:, 2:end), d_train(:, 1), d_train(:, 2:end));
    m_train = m_train(:, 1)*pm25_std+pm25_mean;
    set(gcf,'color','white','paperpositionmode','auto');
    subplot(2, 1, 1);
    plot(1:length(m_train), m_train, 'r*');
    hold on;
    plot(1:length(m_train), y_ground_train, 'b.');
    rmse_tr = sqrt(sum((m_train-y_ground_train).*(m_train-y_ground_train))/length(m_train));
    title(['train : ' num2str(rmse_tr)]);
    hold off;
    RMSE_tr(i) = rmse_tr;
    
    % 展示预测效果
    [m_test, s_test] = gp(hyp, @infExact, [], covfunc, likfunc, d_train(:, 2:end), d_train(:, 1), d_test(:, 2:end));
    m_test = m_test(:, 1)*pm25_std+pm25_mean;
    subplot(2, 1, 2);
    plot(1:length(m_test), m_test, 'r.');
    hold on;
    plot(1:length(m_test), y_ground_test, 'b.');
    rmse_ts = sqrt(sum((m_test-y_ground_test).*(m_test-y_ground_test))/length(m_test));
    title(['test : ' num2str(rmse_ts)]);
    hold off;
    RMSE_ts(i) = rmse_ts;
%     对时间进行分组求和取均值
%     d(:, 2) = roundn(d(:, 2), -3);
%     % 对时间相同的行，求均值
%     tType = unique(d(:, 2));
%     len = length(tType);
%     pt = zeros(len, 1);
%     for i = 1:len
%         pt(i) = mean(d(d(:, 2)==tType(i), 1)); %对时间分组求均值
%     end
%     figure;
%     plot(tType, pt, 'b.');
%     save pt pt
%     plot(d(:, 3), d(:, 4), 'r.');
end
figure;
RMSE_tr = [0 RMSE_tr];
RMSE_ts = [0 RMSE_ts];
bar(RMSE_tr);
figure;
bar(RMSE_ts);