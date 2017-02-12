
function Yh = Online_Learning_LGP(X_train,Y_train,Max_Size,lim,LearnHyp,OnlineTrain,InfoGain)
%
%
% This procedure employs local Gaussian process regression (LGP) for an online 
% learning process. Here, the data is given sequentially to the learning procedure. 
% For more information see:
%
% Nguyen-Tuong, Duy; Seeger, Matthias; Peters, Jan (2009). 
% Model Learning with Local Gaussian Process Regression, 
% Advanced Robotics, 23, 15, pp.2015-2034
% 
% Note: For optimization of the hyperparameters, the toolbox LHOTSE is required. 
% (http://people.mmci.uni-saarland.de/~mseeger/lhotse/index.html). 
% If other optimization toolbox is used, this Matlab-file needs to be accordingly adapted.  
%
% Input:
% X_train,Y_train   ..... Data for training / learning hyper-parameters
% lim               ..... Limit value for generation of new local models
% LearnHyp          ..... Flag: learning of hyper-parameters (1 or 0)
% OnlineTrain       ..... Flag: online learning given hyper-parameters (1 or 0)
% InfoGain          ..... Flag: using information gain for data removal (1 or 0)
% 
% Output:
% Yh                ..... Online prediction
%
% 
% Copyright (C) 2009 by Duy Nguyen-Tuong 
% Max Planck Institute for Biological Cybernetics
% 72076 Tübingen, Germany
% 
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
%


%%%%% Define global variables %%%%%%%
global X Y C H_pred LocNr UpdateNr Total_Nr KernMat InvKernMat


% Initialization
X=cell(1,1); Y=cell(1,1);
KernMat=cell(1,1); InvKernMat=cell(1,1);

H_pred=[];
C=[]; Yh=[]; Dist=[];

LocNr=0;
UpdateNr=0;
Total_Nr=0;
LocIndex=0;

% Localization dimension
LocDim = 1;     
% Info-Gain threshold
GainLimit = 0.01;

if (LearnHyp == 1 && OnlineTrain == 0)
% Optimizing hyper-parameters using LHOTSE. If other optimizer is used,
% this part of the function needs to be changed. 

    
    % Path to LHOTSE
    progPath = '/home/nty2si/Prog/lhotse/';
    
    % Data for hyper-parameter optimization
    X_Input = X_train;
    Y_Input = Y_train;

    % Initial values for the hyper-parameters 
    Hyp = [ones(1,size(X_Input,2)),1,0.1];
    
    % Conversion to LOHTSE-Format
    savebasevector(log(Hyp),'hyper_init.stv',6);
    savebasematrix(X_Input,'x_train.bmf',5);
    savebasevector(Y_Input,'y_train.bmf',6);

    % Call optimization procedure for hyperparameters
    curPath = pwd;
    cmd = [progPath, 'gpregr ', 'gpr1-learn-hyper.ctl'];
    disp('cmd'); disp(system(cmd)); cd(curPath);

    % Read optimized hyper-parameters from LHOTSE
    hyper = loadbasevector('gpr1-hyper_res.stv');
    H_pred= exp(hyper);

    % Save hyper-parameters
    eval(['save ' 'LGP_Hyper' ' H_pred']);
    % Print some info
    display('Learning Hyperparameters finished !!');
    

else if (OnlineTrain == 1 && LearnHyp == 0)
% Online-Training + Online-Localization + Online-Prediction using LGP.
% The learning and prediction procedure can be performed when 
% the hyper-parameters are learned.
    
        % load hyper-parameters optimized with LHOTSE
        eval(['load ' 'LGP_Hyper']);

        % Data for training
        X_in = X_train;
        Y_in = Y_train;
    
        % Nr. of test points
        s=size(X_in,1);
        
        % Pass the training data incrementally
        for k=1:s

            % Input point
            in  = X_in(k,:);
            % Localization point
            inW = X_in(k,1:LocDim);
            % Target point
            tau = Y_in(k);

            if (LocNr >= 1)
            % Localize data point, if models are available 
            
                % Compute distance to each local model
                for j=1:LocNr
                    S = (inW-C(j,:)).^2*H_pred(1:LocDim);
                    Dist(j) = exp(-0.5*S);
                end

                % Find local models in the neighbourhood
                [Dist,LocIndex] = sort(Dist,'descend');
                
                % Online-prediction of query point
                Yh(k) = Pred_LGP(in,LocIndex(1));

                % Localization of query point:
                % Insert the query point to nearest local model.
                Local_LGP(in,tau,lim,LocDim,LocIndex(1),Dist(1),Max_Size,InfoGain,GainLimit);
                
            else
            % If no local models are available, generate a new model
            % This happens in the very first step.
            
                Local_LGP(in,tau,lim,LocDim,0,0,Max_Size,InfoGain,GainLimit);

                % Local Prediction
                Yh(k) = 0;

            end
           
            % Print some info 
            %display(['PredModel: ' num2str(LocIndex(1))])
            %display(['LocModel : ' num2str(LocNr)])
            %display('XXXXXXXXXXXXXXXXXXX')
            %if (mod(k,100)==0)
            %   display([num2str(k) '. Data point ...'])
            %end

        end
        
        % Plot online prediction results
%         figure
%         plot(Y_in,'*');hold on
%         plot(Yh,'--r')
% %         
        display('Online-training & Online-prediction using local models done ...')

    else
        % Error message
        error('Please set correct flags !!');
    end
    
end

    % Print some info 
    display(['Data points: ' num2str(size(X_train,1))]);
    display(['Number of local models: ' num2str(LocNr)]);
            
end % End of main function



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Subfunction for prediction of query points
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Sum=Pred_LGP(in,LocIndex)

% Define global variables
global X Y H_pred InvKernMat

KernVec = cell(1,1);

% Dimension of input data
dim=size(H_pred,1)-2;

% Calculate Kernel-vector
SizeNr=size(LocIndex,2);
for j=1:SizeNr
    rowNr=size(X{1}{LocIndex(j)},1);
    for i=1:rowNr
        K = (in-X{1}{LocIndex(j)}(i,:)).^2*H_pred(1:dim);
        KernVec{j}(i) = H_pred(dim+1)*exp(-0.5*K);
    end
end

% Prediction using local models
Sum=0;
for j=1:SizeNr
    s=size(X{1}{LocIndex(j)},1);
    % Prediction vector
    PredVec = InvKernMat{1}{LocIndex(j)}*Y{1}{LocIndex(j)};
    % Local prediction
    S = KernVec{j}*PredVec;
    % Sum of weighted local predictions
    Sum = Sum + S;
end


end % End of prediction 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                           
%   Subfunction for localization of data points       
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Local_LGP(in,tau,lim,LocDim,in_max,h,Max_Size,InGain,GainLimit)

%%%%% Define global variables
global X Y C LocNr UpdateNr Total_Nr


if (size(C,1)==0 || h < lim)

    % No model available or training point does not fit to any model !!
    % Training point is now new center.
    LocNr = LocNr+1;

    % counter
    UpdateNr = UpdateNr+1;
    Total_Nr = Total_Nr+1;

    % new center
    C = [C ; in(1:LocDim)];

    % Create new model
    X{1}= [X{1}  ; cell(1,1)];
    Y{1}= [Y{1}  ; cell(1,1)];

    % Write new point to model
    X{1}{end} = [X{1}{end} ;in];  % input point
    Y{1}{end} = [Y{1}{end} ;tau]; % target point

    % Compute Covariance matrix
    Compute_Kern(LocNr,in);

    %display(['Create new local model: ' num2str(LocNr)]);

else

    % Put training point into corresponding local model
    % using "hard limit value", i.e.
    % take model which is next to training point.


    % Check the size of local model
    S = size(X{1}{in_max},1);

    if (S > Max_Size)
        % Insert new training point to the nearest model !
        % And randomly delete another point.

        if(InGain == 1)

            % Compute Information Gain
            InfG = Compute_InfoGain(in_max,in,tau);

            if(InfG > GainLimit)

                % Insert data point to model

                % counter
                UpdateNr = UpdateNr+1;
                Total_Nr = Total_Nr+1;

                % Take a random number
                a=1; b=S;
                LocMem = a + (b-a).*rand(1,1);
                LocMem = floor(LocMem);

                %display(['DataPt: ' num2str(LocMem)]);

                % Update training data
                X{1}{in_max}(LocMem,:) = in;

                % Update target data
                Y{1}{in_max}(LocMem) = tau;

                % Compute Covariance matrix
                Compute_Kern(in_max,in,LocMem);

            end

        else   

            % counter
            UpdateNr = UpdateNr+1;
            Total_Nr = Total_Nr+1;

            % Take a random number
            a=1; b=S;
            LocMem = a + (b-a).*rand(1,1);
            LocMem = floor(LocMem);

            %display(['DataPt: ' num2str(LocMem)]);

            % Update training data
            X{1}{in_max}(LocMem,:) = in;

            % Update target data
            Y{1}{in_max}(LocMem) = tau;

            % Compute Covariance matrix
            Compute_Kern(in_max,in,LocMem);

        end

    else

        % counter
        UpdateNr = UpdateNr+1;
        Total_Nr = Total_Nr+1;

        % Insert new training point to the nearest model !
        X{1}{in_max} = [X{1}{in_max} ; in];
        Y{1}{in_max} = [Y{1}{in_max} ; tau];

        % Compute Covariance matrix
        Compute_Kern(in_max,in);

    end

    % Print info
    %display(['ModelNr  : ' num2str(in_max)]);
    %display(['ModelSize: ' num2str(size(X{1}{in_max},1))]);

end

end % End of localization



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Subfunction for computing covariance matrix of local models
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Compute_Kern(modelNr,X_in,ModelInd)


%%%%% Define global variables
global X Y H_pred KernMat InvKernMat

% Nr. of training points in local model
n=size(Y{1}{modelNr},1);
% Dimension of input data
dim=size(H_pred,1)-2;

if(nargin == 1)
    
    % Compute complete Covariance matrix
    for m=1:n

        X_m = X{1}{modelNr}(m,:);
        for k=1:n

            X_k = X{1}{modelNr}(k,:);
            % Distance
            Dist = (X_m-X_k).^2*H_pred(1:dim);
            % Covariance matrix
            KernMat{1}{modelNr}(m,k)= H_pred(dim+1)*exp(-0.5*Dist);
            % Add sigma-noise to diagonal
            if (m==k)
                KernMat{1}{modelNr}(m,k) = KernMat{1}{modelNr}(m,k)+H_pred(dim+2);
            end
        end
    end

elseif(nargin == 2)
    
    % Update Covariance matrix by inserting new training point
    K=[];
    for j=1:n
        K(j) = H_pred(dim+1)*exp(-0.5*(X_in-X{1}{modelNr}(j,:)).^2*H_pred(1:dim));
    end
    K(end)=K(end)+H_pred(dim+2);

    % Update matrix
    if(n > 1)
        KernMat{1}{modelNr}=[KernMat{1}{modelNr};K(1:end-1)];
        KernMat{1}{modelNr}=[KernMat{1}{modelNr}';K]';
    else
        KernMat{1}{modelNr}(n,n)=K;
    end
    
elseif(nargin == 3)

    % Update Covariance matrix by inserting new training point
    % And additionally remove another point
    for j=1:n
        K = (X_in-X{1}{modelNr}(j,:)).^2*H_pred(1:dim);
        if(j==ModelInd)
            KernMat{1}{modelNr}(j,j)=H_pred(dim+1)*exp(-0.5*K)+H_pred(dim+2);
        else
            KernMat{1}{modelNr}(ModelInd,j)=H_pred(dim+1)*exp(-0.5*K);
            KernMat{1}{modelNr}(j,ModelInd)=H_pred(dim+1)*exp(-0.5*K);
        end
    end

else

    error('Wrong number of inputs !!');

end

% Compute Inverse Covariance matrix
InvKernMat{1}{modelNr}=inv(KernMat{1}{modelNr});


end % End of computing kernels



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Subfunction for computing Information Gain
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function InfG=Compute_InfoGain(modelNr,X_in,Y_in)

global X Y H_pred InvKernMat

%display('Compute Information Gain !')

% Dimension of input data
dim=size(H_pred,1)-2;

% Calculate Information Gain
K=[];
SizeLoc = size(X{1}{modelNr},1);
for j=1:SizeLoc
    K(j) = H_pred(dim+1)*exp(-0.5*(X_in-X{1}{modelNr}(j,:)).^2*H_pred(1:dim));
end
sig=H_pred(dim+2);
k_star = H_pred(dim+1)+sig;
y_star = Y_in;

InvK = InvKernMat{1}{modelNr};

alpha = 1/(k_star+sig-K*InvK*K');
V = [-alpha*InvK*K' ; alpha];
K_star = y_star-(sig/(1+sig*alpha))*V'*[Y{1}{modelNr};y_star];

% Information Gain
InfG = 0.5*(log(1+sig*alpha)-sig*alpha/(1+sig*alpha)+(K_star^2/sig)*[K k_star]*V);

end





