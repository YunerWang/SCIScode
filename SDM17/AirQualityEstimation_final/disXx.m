% ????????????????
function dXx = disXx(X, x) % ·µ»Ø nx1
[N, col] = size(X);
dXx = zeros(N, 1);
if col == 1
    x_repmat = ones(N, 1)*x;
    dXx = x_repmat-X;
elseif col == 2
    x_repmat = repmat(x, N, 1);
    dXx = sqrt((X(:,1)-x_repmat(:, 1)).^2 + (X(:, 2)-x_repmat(:, 2)).^2);
end
end