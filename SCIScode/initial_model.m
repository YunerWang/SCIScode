function hyp_model = initial_model(Q, iteration, covfunc, hyp_cell, likfunc, meanfunc)
    hyp_model = cell(1);
    hyp_model.Q = Q;
    hyp_model.iteration = iteration;
    hyp_model.covfunc = covfunc;
    hyp_model.hyp_cell = hyp_cell;
    hyp_model.likfunc = likfunc;
    hyp_model.meanfunc = meanfunc;
end