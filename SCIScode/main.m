clear;clc;close all;

load data_norm;
load pm25_mean;
load pm25_std;

rand('seed', 7);
Kappa = 9;
iteration = 20;

hyp_cell = cell(1);
% cov function
Q = 2;
% covfunc = {@covSDM_noise, Q};
% hyp_cell.cov = log(rand(1, 3*Q+2*(9-3)+1));
covfunc = {@covSM, Q};
hyp_cell.cov = log(rand(1, (1+2*8)*Q));
% covfunc = {@covSEiso};
% hyp_cell.cov = log(rand(1, 2));

% lik function
likfunc = @likGauss;
hyp_cell.lik = log(0.1);

% mean function
meanfunc = [];

% 固定五百个测试点
hyp_model = initial_model(Q, iteration, covfunc, hyp_cell, likfunc, meanfunc);
result = zeros(1, 4);
i = 1;
for samples = [1000 5000 10000 20000]
    rmse_bst = inf;
    for idx = [1000 10000 30000 50000]
        if i == 2 || i == 3
            Kappa = 10;
        else
            Kappa = 9;
        end
        train_range = idx : (idx+samples-1);
        test_range = idx+samples+randperm(1000);
        test_range = sort(test_range(1:100));
        
        if samples <= 2^(Kappa-1)
            hyp_model.layer_std = 1;
        else
            hyp_model.layer_std = ceil(log2(samples))-Kappa+1;
        end
        % train model
        train_set = data_norm(train_range, :);
        [model, train_time] = train_model(hyp_model, train_set);
        model.train_set = train_set;
        
        % test model
        test_x = data_norm(test_range, 2:end);
        test_y = data_norm(test_range, 1)*pm25_std+pm25_mean;
        [test_result, test_time] = test_model(model, hyp_model, train_set, test_x);
        test_result = test_result*pm25_std+pm25_mean;
        test_result = abs(test_result);
        
        figure;
        plot(test_x(:, 2), test_result(:, 1), 'r.');
        hold on;
        plot(test_x(:, 2), test_y(:, 1), 'b.');
        % 选择最佳结果
        rmse = sqrt(sum((test_result-test_y).^2)/size(test_x, 1));
        if rmse < rmse_bst
            rmse_bst = rmse;
            models(i) = model; 
        end
    end
    result(i) = rmse_bst;
    i = i+1;
end
save models models;
save result result;


