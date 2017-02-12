function subset = dataFilter(origin_data, x, theta, hyp, Q)
% 数据过滤机制
% function subset = dataFilter(origin_data, KXx, theta)
% 计算 k(x_*, X)， KXx: nxa的矩阵
    % SE_PARA_NUM = 13;
    % Q = (length(hyp) - SE_PARA_NUM) / 3;
    %KXx = covSM(Q, hyp, origin_data(:, 2), x);
    %KXx = computeKTXx(origin_data, x, Q, hyp);
    %KXx_a = sum(KXx, 1);
    %KXx_a = theta * KXx_a;
    %final_idx = KXx(:, 1) > theta;
    %du
%     final_idx = zeros(size(origin_data(:, 2)));
%     for j = 1:Q
%         L = 2 * pi / hyp((j-1) * 3 + 2); 
%         final_idx = final_idx | mod(abs(origin_data(:, 2) - x(1)), L) < theta;
%     end
%     subset = origin_data(final_idx, :);
%     KXx_sum = sum(KXx)*theta;
%   du
    %du2
     final_idx = zeros(size(origin_data(:, 2)));
     for j = 1:Q
         m = hyp((j-1) * 3 + 2);
         L = 2 * pi / m; 
         final_idx = final_idx | mod(abs(origin_data(:, 2) - x(1)), L) < theta / m;
     end
     subset = origin_data(final_idx, :);
    % KXx_sum = sum(KXx)*theta;
    %du2

%     [vals , index] = sort(KXx, 'descend');
%     subset = origin_data(index(1:theta), :);
end

