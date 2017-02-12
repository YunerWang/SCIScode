%用于实验选择论文参数\kappa的大小
    Q = 2;
    size_limit = 50;
    samples = 10000;
    train_range = 21000 : 31000 ;
    test_range = 31000 : 31500;
    result_kappa = cell(4, 1);
    for kappa = 11:11
        disp(kappa);
        layer_std = ceil(log2(samples))-kappa+1; 
        [est y rmse traintime testtime] = model(train_range, test_range, 5, 240, layer_std, size_limit, 800);
        result_kappa{kappa - 6}.est = est;
        result_kappa{kappa - 6}.rmse = rmse;
        result_kappa{kappa - 6}.y = y;
        result_kappa{kappa - 6}.traintime = traintime;
        result_kappa{kappa - 6}.testtime = testtime;
        result_kappa{kappa - 6}.kappa = kappa;
        result_kappa{kappa - 6}.train_range = train_range;
        result_kappa{kappa - 6}.Q = Q;
        result_kappa{kappa - 6}.test_range = test_range;
        result_kappa{kappa - 6}.theta_minu = 240;
        save result_kappa1 result_kappa
    end


