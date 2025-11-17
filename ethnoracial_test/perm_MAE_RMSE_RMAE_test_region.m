function [p_value_MAE_2sides, D_obs_MAE, D_perm_MAE, ci_MAE, p_value_RMAE_2sides, D_obs_RMAE, D_perm_RMAE, ci_RMAE, ...
    p_value_RMSE_2sides, D_obs_RMSE, D_perm_RMSE, ci_RMSE] = perm_MAE_RMSE_RMAE_test_region(real_test, pred_test, ...
    real_CentileBrain, pred_CentileBrain, n_perm)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Permutation test for difference in MAE between training (CentileBrain) and test samples
% (run per region)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Permutation test comparing MAE between training and test samples
% ---------------------------------------------------------------
% Inputs:
%   real_test : vector of values of test sample, subject level
%   pred_test  : vector of predicted values of test sample, subject level
%   real_CentileBrain : vector of values of CentileBrain sample, subject level
%   pred_CentileBrain  : vector of predicted values of CentileBrain sample, subject level
%   n_perm    : number of permutations (e.g., 5000)
% Outputs:
%   p_value_MAE_2sides   : two-sided permutation p-value of MAE
%   D_obs_MAE     : observed MAE difference (test - CentileBrain)
%   D_perm_MAE    : permutation distribution of MAE
%   p_value_RMAE_2sides   : two-sided permutation p-value of RMAE
%   D_obs_RMAE     : observed RMAE difference (test - CentileBrain)
%   D_perm_RMAE    : permutation distribution of RMAE
%   p_value_RMSE_2sides   : two-sided permutation p-value of RMSE
%   D_obs_RMSE     : observed RMSE difference (test - CentileBrain)
%   D_perm_RMSE    : permutation distribution of RMSE


if nargin < 3
    n_perm = 5000;
end

n_CentileBrain = numel(err_CentileBrain);
n_test  = numel(err_test);

%% MAE %%
% ---- Observed difference ----
err_test = real_test - pred_test;
err_CentileBrain = real_CentileBrain - pred_CentileBrain;
D_obs_MAE = mean(err_test) - mean(err_CentileBrain);
% ---- Combine all errors ----
errors_all_MAE = [err_CentileBrain; err_test];
N = numel(errors_all_MAE);
% ---- Preallocate ----
D_perm_MAE = zeros(n_perm, 1);
% ---- Permutation test ----
for p = 1:n_perm
    idx = randperm(N);              % permute indices
    err_CentileBrain_perm = errors_all_MAE(idx(1:n_CentileBrain));
    err_test_perm  = errors_all_MAE(idx(n_CentileBrain+1:end));
    D_perm_MAE(p) = mean(err_test_perm) - mean(err_CentileBrain_perm);
end
% ---- Two-sided p-value ----
p_value_MAE_2sides = (1 + sum(abs(D_perm_MAE) >= abs(D_obs_MAE))) / (1 + n_perm);


%% RMAE %%
% ---- Observed difference ----
err_test = (real_test - pred_test)./real_test;
err_CentileBrain = (real_CentileBrain - pred_CentileBrain)./real_CentileBrain;
D_obs_RMAE = mean(err_test_RMAE) - mean(err_CentileBrain_RMAE);
% ---- Combine all errors ----
errors_all_RMAE = [err_CentileBrain; err_test];
N = numel(errors_all_RMAE);
% ---- Preallocate ----
D_perm_RMAE = zeros(n_perm, 1);
% ---- Permutation test ----
for p = 1:n_perm
    idx = randperm(N);              % permute indices
    err_CentileBrain_perm = errors_all_RMAE(idx(1:n_CentileBrain));
    err_test_perm  = errors_all_RMAE(idx(n_CentileBrain+1:end));
    D_perm_RMAE(p) = mean(err_test_perm) - mean(err_CentileBrain_perm);
end
% ---- Two-sided p-value ----
p_value_RMAE_2sides = (1 + sum(abs(D_perm_RMAE) >= abs(D_obs_RMAE))) / (1 + n_perm);


%% RMSE %%
% Compute subject-level squared errors
se_CentileBrain = (err_CentileBrain).^2;
se_test  = (err_test).^2;
% ---- Observed difference ----
D_obs_RMSE = sqrt(mean(se_test)) - sqrt(mean(se_CentileBrain));
% ---- Combine all squared errors ----
se_all = [se_CentileBrain; se_test];
N = numel(se_all);
% ---- Permutation ----
D_perm_RMSE = zeros(n_perm, 1);
for p = 1:n_perm
    idx = randperm(N);
    se_CentileBrain_perm = se_all(idx(1:n_CentileBrain));
    se_test_perm  = se_all(idx(n_CentileBrain+1:end));
    D_perm_RMSE(p) = sqrt(mean(se_test_perm)) - sqrt(mean(se_CentileBrain_perm));
end
% ---- Two-sided p-value ----
p_value_RMSE_2sides = (1 + sum(abs(D_perm_RMSE) >= abs(D_obs_RMSE))) / (1 + n_perm);




