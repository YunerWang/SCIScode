%
% This script gives an example, how to call the LGP code
%
% Note: For learning the hyper-parameters, the toolbox LHOTSE is required
% (http://people.mmci.uni-saarland.de/~mseeger/lhotse/index.html).
% In case the hyper-parameters are learned using other optimization
% methods, the file 'Online_Learning_LGP' needs to be adapted.
%

clear all
close all

% Load example data: 
% This is the well-known "motor cycle data" featuring the different input dependent noise.

load MotorCycle_Data

% Learning the hyper-parameters using LHOTSE-Toolbox
% See (http://people.mmci.uni-saarland.de/~mseeger/lhotse/index.html)

Yh=Online_Learning_LGP(x,y,0,0,1,0,0); % If you don't have LHOTSE and 
                                       % just want to test the online training & prediction,
                                       % you can comment out this line. The
                                       % previously optimized hyper-parameters 
                                       % for this data set will be used.

% Using the learned hyper-parameters, online training & prediction can be performed. 

Max_Size = 60; % maximal number of data points
lim = 0.5;     % limit value for generation of new local models
Yh = Online_Learning_LGP(x,y,Max_Size,lim,0,1,0);
title('Online Training & Prediction with N=60')

% Optionally, information gain criteria can be employed for loca data removal.

Max_Size = 5; % maximal number of data points
Yh = Online_Learning_LGP(x,y,Max_Size,lim,0,1,1);
title('Online Training & Prediction with N=5 and using Information Gain')