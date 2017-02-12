% draw choose kappa
% clear;clc;
% re = importdata('result_kappa_huiZong.mat');
% n = 5;
% 
% traintime = zeros(5, 1);
% testtime = zeros(5, 1);
% kappa = zeros(5, 1);
% rmse = zeros(5, 1);
% mae = zeros(5, 1);
% for i = 1:5
%     traintime(i) = re{i}.traintime;
%     testtime(i) = re{i}.testtime;
%     kappa(i) = re{i}.kappa;
%     rmse(i) = re{i}.rmse;
%     mae(i) = sum(abs(re{i}.est-re{i}.y))/length(re{i}.est);
%     re{i}.mae = mae(i);
% end

% draw
% rmse:
% x =1:n;
% subplot(1, 2, 1);
% bar(x, rmse);
% 
% subplot(1, 2, 2);
% bar(x, traintime);


