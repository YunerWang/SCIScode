function [model, train_time] = train_model(hyp_model, train_set)
% training model with the input parameters
% INPUT:
%   hyp_model: the parameter for training model
% OUTPUT:
%   model: the struct of the trained model
model = cell(1);
train_time = 0;
% build tree
t1 = clock;
tree = kd_buildtree(train_set, 0);
nodeset_cell = generateSubset(tree, 1, hyp_model.layer_std);
t2 = clock;
train_time = train_time + etime(t2, t1);

% 预设核函数的超参数
n_nodeset = size(nodeset_cell, 2);

hyp_subset(1:n_nodeset) = hyp_model.hyp_cell; % 每个子学习器的学习参数

likfunc = hyp_model.likfunc;
covfunc = hyp_model.covfunc;

subset_cell = cell(n_nodeset, 1);

% 训练子学习器
for i = 1:n_nodeset
    subset_cell{i} = train_set(nodeset_cell{i}.recordnum, :);
    subset_x = subset_cell{i}(:, 2:end);
    subset_y = subset_cell{i}(:, 1);
    
    t1 = clock;
    hyp_subset(i) = minimize(hyp_subset(i), @gp, -hyp_model.iteration, @infExact, [], covfunc, likfunc, subset_x, subset_y);
    t2 = clock;
    train_time = train_time+etime(t2, t1);
end

% save the model
model.nodeset_cell = nodeset_cell;
model.tree = tree;
model.hyp_subset = hyp_subset;
model.train_time = train_time;

end