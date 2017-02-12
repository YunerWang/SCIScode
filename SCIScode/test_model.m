function [test_result, test_time] = test_model(model, hyp_model, train_set, test_x)
% testing trained model using test_x
n_test = size(test_x, 1);
n_node = length(model.nodeset_cell);
estimation = zeros(n_test, n_node);
weight = zeros(n_test, n_node);
test_time = 0;
covfunc = hyp_model.covfunc;
likfunc = hyp_model.likfunc;
for i = 1:n_node
    subset_x = train_set(model.nodeset_cell{i}.recordnum, 2:end);
    subset_y = train_set(model.nodeset_cell{i}.recordnum, 1);
    
    % compute the estimation
    t1 = clock;
    [estimation(:, i), ~] = gp(model.hyp_subset(i), @infExact, [], covfunc, likfunc, subset_x, subset_y, test_x);
    t2 = clock;
    test_time = test_time + etime(t2, t1);
    for j = 1:n_test
        weight(j, i) = sum(feval(covfunc{:}, hyp_model.hyp_cell.cov, subset_x, test_x(j, :)));
    end
end
test_result = sum(estimation .* weight, 2)./sum(weight, 2);
test_time = test_time / n_test;
end