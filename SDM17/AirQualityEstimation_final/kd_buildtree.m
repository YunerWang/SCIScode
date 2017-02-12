% 构建KD-tree
function tree_output = kd_buildtree(X, plot_suff, parent_number, split_dimension, layer_idx)

% 10/02/2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUTS
% X --- contains the data (nxd) matrix, d is the dimensionality of each (feature & y) vector and
%               n is the number of feature vectors
% parent_number --- Internal variable .... Donot Assign
% split_dimension ---Internal variable .... Donot Assign


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUTS 
% tree_output --- contains the a array of structs, each struct is a node 
%                 node in the tree. The size of the array is equal to the
%                 number of feature vectors in the data matrix X

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% each struct in the output cell array contains the following information
% left - (tree) left tree node location in the array
% right - (tree) right tree node location in the array
% numpoints - number of points in this node
% nodevector - the median of the data along dimension that it is split
% hyperrect - (2xd) hyperrectangle bounding the points
% type - 'leaf' = node is leaf
%        'node' = node has 2 children
% parent - the location of the parent of the current node in the struct
%           array
% index - the index of the feature vector in the original matrix that was
%         used to build the tree
% splitdim - the dimension along which the split is made
% splitval - the value along that dimension in which the split is made.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global tree_cell;
global node_number;

if nargin == 2
    % add the index values to the last column
    % easy way to keep track of them
    [n, d] = size(X);
    X(:, d+1) = (1:n)';
    node_number = 1;
    split_dimension = 0;
    parent_number = 0;
    layer_idx = 0;

    
    % intialize the node
    Node.type = 'node';
    Node.left = 0;
    Node.right = 0;
    Node.nodevector = zeros(1, d);
    Node.hyperrect = [zeros(1,2);zeros(1,2)];
    Node.numpoints = 0;
    Node.index = 0;
    Node.parent = 0;
    Node.splitval = 0; 
	Node.recordnum = -1; % 记录节点对应的观测值
    
    % initilize the tree
    hold_cell_data(1:n) = Node;
    tree_cell = hold_cell_data;
    clear hold_cell_data;
else
    [n, d] = size(X(:, 1:end-1));
    node_number = node_number+1;
    split_dimension = split_dimension + 1;
end



assigned_nn = node_number; % assigned node number for this particular iteration

% set assignments to current node
tree_cell(assigned_nn).type = 'node';
tree_cell(assigned_nn).parent = parent_number;
tree_cell(assigned_nn).recordnum = X(:, end);

% if it is a leaf
if n == 1 
    tree_cell(assigned_nn).left=[];
    tree_cell(assigned_nn).right=[];
    tree_cell(assigned_nn).nodevector=X(:, 1:end-1);
    tree_cell(assigned_nn).hyperrect=[X(:, 3:4);X(:, 3:4)];
    tree_cell(assigned_nn).type='leaf';
    tree_cell(assigned_nn).numpoints=1;
    tree_cell(assigned_nn).index=X(:, end);
    
    if plot_suff == 1
        kd_plotbox(assigned_nn, 'node');
    end

    tree_output = assigned_nn;
    return;
end

tree_cell(assigned_nn).numpoints = n;
a = min(X(:, 3:4));
b = max(X(:, 3:4));
tree_cell(assigned_nn).hyperrect = [a;b];

% if it is not a leaf

% figure out which dimension to split (going in order)
% tree_cell(assigned_nn).splitdim=mod(split_dimension, 2)+3 % 只用经纬度画
tree_cell(assigned_nn).splitdim=mod(split_dimension, 7)+3; % 用3：end的属性画
% figure out the median value to cut this dimension
median_value=median(X(:, tree_cell(assigned_nn).splitdim));
% find out all the values that are lower than or equal to this median
i = find(X(:, tree_cell(assigned_nn).splitdim)<=median_value);
j = find(~(X(:, tree_cell(assigned_nn).splitdim)<=median_value));
if size(X, 1) == size(i, 1) 
    j = i(floor(size(i, 1)/2)+1:end);
    i = i(1:floor(size(i, 1)/2));
end
% if there are more than 2 points
if(tree_cell(assigned_nn).numpoints>2)
    [max_val, max_pos]=max(X(i, tree_cell(assigned_nn).splitdim));
    tree_cell(assigned_nn).left = kd_buildtree(X(i, :), plot_suff, assigned_nn, split_dimension, layer_idx+1);
    % recurse for everything to the right of the median
    if(size(X,1)>size(i, 1))
        
        tree_cell(assigned_nn).right = kd_buildtree(X(j, :), plot_suff, assigned_nn, split_dimension, layer_idx+1);
    else 
        tree_cell(assigned_nn).right = [];
  
    end
else
    % if there are only two data points left
    % choose the left value as the median
    % make the right value as a leaf
    % leave the left leaf blank
    [max_val, max_pos] = max(X(i, tree_cell(assigned_nn).splitdim));
    if (i(max_pos) == 1)
        min_pos = 2;
    else
        min_pos = 1;
    end
    tree_cell(assigned_nn).left = [];
 
    tree_cell(assigned_nn).right = kd_buildtree(X(min_pos, :), plot_suff, assigned_nn, split_dimension, layer_idx+1);
end
% assign the median vector to this node
tree_cell(assigned_nn).nodevector = X(i(max_pos), 1:end-1);
tree_cell(assigned_nn).index = X(i(max_pos), end);
tree_cell(assigned_nn).splitval = X(i(max_pos), tree_cell(assigned_nn).splitdim);

% plot stuff if you want to
if plot_suff == 1
    kd_plotbox(assigned_nn, 'node');
end
if plot_suff == 1
    kd_plotbox(assigned_nn, 'box');
end

% final clean up
if nargin == 2
    % As all computation is complete then return tree structure
    % and clear other data
    tree_output = tree_cell;
    clear global tree_cell;

else
    % otherwise output the assigned_nn for storage in the parent
    tree_output = assigned_nn;
end