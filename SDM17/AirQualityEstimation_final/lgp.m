% 局部高斯过程回归
function [esti weight testtime] = lgp(hyp, covfunc, likfunc, subset, test_x)
subset_x = subset(:, 2:end);
subset_y = subset(:, 1);
t1 = clock;
[esti, ~] = gp(hyp, @infExact, [], covfunc, likfunc, subset_x, subset_y, test_x);
t2 = clock;
testtime = etime(t2, t1);
KXx = feval(covfunc{:}, hyp.cov, subset_x, test_x);
weight = sum(KXx);
end