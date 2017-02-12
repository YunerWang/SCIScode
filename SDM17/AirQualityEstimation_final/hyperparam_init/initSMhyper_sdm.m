function hyp_SM = initSMhyper_sdm(Q, x, y)
% hyp_SM: 时间核的参数列表：对每个a (Wa, Va, Ma)
% traintime
hypinit = initSMhypers(Q, x, y);

n_hyp = size(hypinit);

hyp_SM = zeros(n_hyp, 1);
for i = 1:Q
    hyp_SM((i-1)*3+1) = hypinit(i); % for w
    hyp_SM((i-1)*3+2) = hypinit(i+2*Q);% for v
    hyp_SM((i-1)*3+3) = hypinit(i+Q); % for m
end
end