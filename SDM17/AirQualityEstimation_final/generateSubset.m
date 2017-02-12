% 生成子学习器的原始数据集
function subset = generateSubset(tree, index, layer_std, layer)
% -----------------------------
% input : tree: the nodes array of a tree
%         index: the index of current node
%         layer_std: the hyper param
%         limit : the records num of a subset
%         layer: the current layer of recursion
% output: the subset for local gp

% global subset_cell;
% global subset_cell_idx;


if nargin == 3 % 第一次进入循环
    % subset_cell_idx = 1;
    layer = 1;
end


points = tree(index);
points.treeno = index;
if(layer == layer_std)
    subset = cell(1);
    subset{1} = points;
    return;
end

subset = [generateSubset(tree, points.left, layer_std, layer+1) generateSubset(tree, points.right, layer_std, layer+1)] ;

end