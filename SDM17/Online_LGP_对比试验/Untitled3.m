clear;clc;
result_lgp = importdata('result_lgp.mat');

name = ['3e2' '5e2' '8e2' '1e3' '3e3' '5e3' '8e3' '1e4' '2e4'];

rmse_lgp = zeros(9, 1);
timecost_lgp = zeros(9, 1);
i = 1;
for samples = [300 500 800 1000 3000 5000 8000 10000 20000]
    rmse_lgp(i) = abs(result_lgp{i}.esti(samples-1)-result_lgp{i}.y(samples-1));
    timecost_lgp(i) = result_lgp{i}.timecost/(samples-1);
    i = i+1;
end

save rmse_lgp rmse_lgp;
save timecost_lgp timecost_lgp;
