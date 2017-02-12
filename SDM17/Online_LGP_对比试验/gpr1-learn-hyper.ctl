#
# gpr1: GP regression, Gaussian noise. Debugging
#

base-filename          = gpr1-

dataset-fname          = x_train.bmf
dataset-targets-fname  = y_train.bmf


# Gaussian kernel
covar-func           = 0

# Matern class 
# covar-func             = 1
# covar-matern-shape     = 3


#hyperpars-fname        = gpr1-hyperpars.stv
#hyperpars-fname        = hyperpars.stv
#noise-sigsq            = 6.92226
#predvec-fname          = predv.stv
#predmeans-fname        = means.stv
#predvars-fname         = vars.stv

# Learning hyperparameters

learn-hyperpars        = 1
optim-code             = 0

# THREE COMPONENTS: [log w, log C, log sigma^2] !!
initpars-fname         = hyper_init.stv

respars-fname          = hyper_res.stv
lbfgs-verbose          = 1
lbfgs-maxev            = 120

# LOG HERE!!
logsigsq-lower         = -18.9078  #   -6.9078 -18.4207

# For LHOTSE BFGS:

#bfgs-reltol            = 1e-6
bfgs-reltol           = 1e-4
bfgs-bound             = 30
#bfgs-bound            = 40
bfgs-restart           = 20
bfgs-verbose           = 1
bfgs-test-gradients    = 0

bfgs-bertsek           = 1
bfgs-ls-bound          = 5
bfgs-ls-gamma          = 2.0
bfgs-ls-rho            = 0.01
bfgs-ls-kappa          = 0.2
bfgs-ls-incrfact       = 50
bfgs-ls-sigma          = 0.2
bfgs-ls-tau            = 0.1
bfgs-ls-backoff        = 0
