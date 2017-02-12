% ∂‘±» ‘—È
clear all; close all;

data = importdata('data_norm.mat');
pm25_max = importdata('pm25_max.mat');
pm25_min = importdata('pm25_min.mat');
pm25_mean = importdata('pm25_mean.mat');

Max_size = 60;
lim = 0.5;

result_lgp = cell(9, 1);
idx = 1;
for samples = [300 500 800 1000 3000 5000 8000 10000 20000]
    range = (31000-samples+1):31000;
    train_x = data(range, 2);
    train_y = data(range, 1);
    t1 = clock;
    esti = Online_Learning_LGP(train_x, train_y, 60, 0.5, 0, 1, 0);
    t2 = clock;
    timecost = etime(t2, t1);
    esti(1) = [];
    train_y(end) = [];
    esti = (esti+pm25_mean)*(pm25_max-pm25_min)+pm25_min;
    train_y = (train_y+pm25_mean)*(pm25_max-pm25_min)+pm25_min;
    tmp_esti = esti';
    result_lgp{idx}.esti = tmp_esti;
    result_lgp{idx}.y = train_y;
    result_lgp{idx}.timecost = timecost;
    result_lgp{idx}.rmse = sqrt(sum((tmp_esti-train_y).^2)/length(esti));
    result_lgp{idx}.samples = samples;
    idx = idx + 1;
end
save result_lgp result_lgp;