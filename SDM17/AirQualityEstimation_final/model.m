function [estimations y_ground rmse traintime testtime] = model(train_range, test_range, Q, theta_minu, layer_std, size_limit, iteration)
% OUTPUT:
%   estimations: 预测值
%   y_ground: 真实值
%   rmse: 评价模型的标准
%   traintime:训练模型
%   testtime: 测试模型
% INPUT:
%   train_range: 训练数据集范围
%   test_range: 测试数据集范围
%   Q: 频率个数
%   theta_minu: dataFilter
%   size_limit: 每个子学习器选出的最小样本数
%   自根往叶子数
%   
% the main flow of AirQualityEstimation
% time_dis: 用于筛选时间最近的样本，样本量
% a 频率的个数
% 2016/10/02
traintime = 0;
testtime = 0;
iteration = -iteration;

%暂时这么写
load('t_max.mat');
load('t_mean.mat');
load('t_min.mat');
theta = (theta_minu)/(t_max-t_min);
% theta = theta_minu;

rand('seed', 7);

data = importdata('data_norm.mat');


pm25_max = importdata('pm25_max.mat');
pm25_min = importdata('pm25_min.mat');
pm25_mean = importdata('pm25_mean.mat');

trainingSet = data(train_range, :);
testingSet = data(test_range, :);
y_ground = (testingSet(:, 1)+pm25_mean)*(pm25_max-pm25_min) + pm25_min;
% training mode
t1 = clock;
tree= kd_buildtree(trainingSet, 0);
nodeset_cell = generateSubset(tree, 1, layer_std); % 返回选中的树节点
t2 = clock;
% figure;
% hold on;
% for i = 1:size(nodeset_cell, 2)
%     recordNum = nodeset_cell{i}.recordnum;
%     datas = trainingSet(recordNum, 3:4);
%     plot(datas(:, 1), datas(:, 2), 'r.');
% end

traintime = traintime + etime(t2, t1);
nn = size(nodeset_cell, 2);
subset_cell = cell(nn, 1);

% 预设超参数
hyp_cell.cov = rand(1, 3*Q+2*(size(trainingSet, 2)-3)+1); % w, sigma, mu, noise
hyp_cell.cov(end) = (rand(1) + 0.2) / 1000; % 给噪声赋特定值
hyp_cell.lik = log(1);
subset_hyp(1:nn) = hyp_cell;
likfunc = @likGauss;
covfunc = {@covSDM_noise, Q}; 
for i = 1:nn
    subset_cell{i} = trainingSet(nodeset_cell{i}.recordnum, :);
    subset_x = subset_cell{i}(:, 2:end);
    subset_y = subset_cell{i}(:, 1);
    % 为每一个子学习器初始化超参数
%     subset_hyp(i).cov(1:3*Q) = initSMhypers(Q, subset_x(:, 1), subset_y);
    % 为每一个子学习器训练超参数
    t1 = clock;
    [subset_hyp(i)] = minimize(subset_hyp(i), @gp, iteration, @infExact, [], covfunc, likfunc, subset_x, subset_y);
    t2 = clock;
    traintime = traintime + etime(t2, t1);
end

% testing model
n_test = size(test_range, 2);
estimations = zeros(n_test, 1);

% cnt_filter = 0;
for j = 1:n_test
    esti = zeros(nn,1);
    weight = zeros(nn,1);
    test_x = testingSet(j, 2:end);
    nearest_id = findNearest(test_x, tree, 1, layer_std);
%     cnt = 0;
    for i = 1:nn
        if nodeset_cell{i}.treeno == nearest_id
%             KXx = feval(covfunc{:}, subset_hyp(i).cov, subset_cell{i}(:, 2:end), test_x);
            subset = dataFilter(subset_cell{i}, test_x, theta, subset_hyp(i).cov, Q);
%             subset = dataFilter(subset_cell{i}, KXx, theta);
        else
            % 2 * theta = time_dis
            subset = dataLatest(subset_cell{i}, test_x, 2 * theta);
%             KXx = feval(covfunc{:}, subset_hyp(i).cov, subset_cell{i}(:, 2:end), test_x);
%             subset = dataFilter(subset_cell{i}, KXx, theta);
        end
%         subset = subset_cell{i};
%         KXx = feval(covfunc{:}, subset_hyp(i).cov, subset_cell{i}(:, 2:end), test_x);
%         subset = dataFilter(subset_cell{i}, KXx, theta);
%         disp(['subset size = ' num2str(size(subset, 1))]);

        %subset = dataFilter(subset_cell{i}, test_x, theta, subset_hyp(i).cov, Q);
        if size(subset, 1) < size_limit
            [~, index] = sort(subset_cell{i}(:, 2), 'descend');
            subset = subset_cell{i}(index(1:size_limit), :);
        end
%        disp(['****************************' num2str(size(subset, 1))]);
       % cnt = cnt + 1;
%         if nodeset_cell{i}.treeno == nearest_id
%             cnt_filter = cnt_filter + 1;
%         end
        [esti(i) weight(i) sub_testtime] = lgp(subset_hyp(i), covfunc, likfunc, subset, test_x);
        testtime = testtime + sub_testtime;
        esti(i) = (esti(i)+pm25_mean)*(pm25_max-pm25_min)+pm25_min;
        if esti(i) < 0
            esti(i) = 0;
        end
        % figure;
        % plot(1:size(esti{i}, 1), esti{i}, 'r');
        % hold on;
        % plot(1:size(esti{i}, 1), y_ground, 'b');
        % figure;
        % plot(1:size(esti{i}, 1), weight{i}, 'b');
        % mae = mean(abs(esti{i}-y_ground))
    end
%     disp(cnt);
%     disp(cnt_filter);
    % 加权和
    estimation = 0;
    weight_sum = 0;
    for i = 1:nn
        estimation = estimation + esti(i)* weight(i);
        weight_sum = weight_sum + weight(i);
    end
    
    estimation = estimation / weight_sum; % column vector
   % estimation = estimation / nn;
    estimations(j) = estimation;
    % error cirtion
    %     figure;
    %     plot(1:size(estimation, 1), estimation, 'r-');
    %     hold on;
    %     plot(1:size(estimation, 1), y_ground, 'b*-');
    %     disp(['mae = ' num2str(mae)]);
end
rmse = sqrt(sum((estimations-y_ground).^2)/n_test);
testtime = testtime/n_test;
end