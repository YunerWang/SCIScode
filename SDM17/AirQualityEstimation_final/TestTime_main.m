clear; clc; close all;
Q = 3;
theta_minu = 20;
size_limit = 50;
iteration = 800;

results_togather = zeros(9, 1);
Kappa = 9;
N = 120000;

int i = 1;
for samples = [300 500 800 1000 3000 5000 8000 10000 20000]
   train_range = 31000 - samples : 31000 - 1;
   test_range = 31000 : 31500 - 1;
   if samples <= 2 ^ (Kappa-1)
         layer_std = 1;
    else
         layer_std = ceil(log2(samples))-Kappa+1;
   end
    [Tmp.tmp_est Tmp.tmp_y Tmp.tmp_rmse Tmp.tmp_traintime Tmp.tmp_testtime] ...
        = model(train_range, test_range, Q, theta_minu, layer_std, size_limit, iteration);
    results_togather(i) = Tmp;
    i = i + 1;
end