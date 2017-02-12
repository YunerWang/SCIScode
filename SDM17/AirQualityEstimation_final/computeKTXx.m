function KXx = computeKTXx(origin, x, a, hyp)
% 计算样本集和测试点之间的核矩阵
% 返回 nxa 的矩阵
origin_t = origin(:, 2);
n = size(origin_t, 1);
x_t = x(1);
dis_time = disXx(origin_t, x_t); % nx1 的矩阵

KXx = zeros(n, a);
for i = 1:a
    KXx(:, i) = hyp((i-1)*a+1)^2 * exp(-2*pi*pi .* dis_time.^2 .* hyp((i-1)*a+2)^2) .* cos(2*pi*dis_time*hyp((i-1)*a+3));
end

end