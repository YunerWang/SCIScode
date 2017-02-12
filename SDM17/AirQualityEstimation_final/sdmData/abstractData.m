% 随机在30000里面取10000的数据

allnum = 120000;
subnum = 80000;

p = randperm(allnum);
idx_vec = sort(p(1:subnum));

load data_norm;
re_data = data_norm(idx_vec, :);
save data_sub re_data;
%dlmwrite('data.txt', re_data, ' ');

