% 找到离目标查询点最近的子学习器
function no = findNearest(x, tree, index, layer_std, layer)
% -----------------------------
% input : tree: the nodes array of a tree
%         index: the index of current node
%         layer_std: the hyper param
%         limit : the records num of a subset
%         layer: the current layer of recursion
% output: the subset for local gp

if nargin == 4 % 第一次进入循环
    layer = 1;
end

points = tree(index);

if(layer == layer_std)
    no = index;
    return;
end

val = points.splitval;
dim = points.splitdim;
left_idx = points.left;
right_idx = points.right;

if x(dim) <= val
    no = findNearest(x, tree, left_idx, layer_std, layer+1);
else
    no = findNearest(x, tree, right_idx, layer_std, layer+1);
end

end