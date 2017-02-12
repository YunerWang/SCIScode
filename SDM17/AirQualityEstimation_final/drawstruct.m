no = size(nodeset_cell, 2);

for i = 1:no
    figure;
    xy = data(nodeset_cell{i}.recordnum, 3:4);
    plot(xy(:, 1), xy(:, 2), 'b.');
end