clear all, close all;
rand('seed', 7);
data = importdata('data_norm.mat');

x = data(1000:1500, 2:end);
y = data(1000:1500, 1);
z = data(1501:1700, 2:end);
ground = data(1501:1700, 1);

Q = 5;
likfunc = @likGauss;
covfunc = {@covSDM_noise, Q};
hyp.cov = rand(1, 3*Q+2*(size(x, 2)-2)+1); 
%hyp.cov = rand(1, Q+2*Q*8); 
hyp.lik = log(0.1);
hyp = minimize(hyp, @gp, -400, @infExact, [], covfunc, likfunc, x, y);

[m s2] = gp(hyp, @infExact, [], covfunc, likfunc, x, y, z);

mae = mean(abs(m-ground)./ground);
disp(['the mae = ' num2str(mae)]);