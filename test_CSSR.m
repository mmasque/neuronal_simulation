%% generate data

TPM = [0.7, 0.3; 0.3, 0.7];

dtmcTPM = dtmc(TPM);

datax = simulate(dtmcTPM, 1000000);
datax = datax - 1;
% do some CSSRing
test_comps = zeros(1, 16);
for i = 1:16
    test_comps(i) = run_CSSR(datax, 'alphabet.txt', i, 0.005, 'two_neurons_gauss_noise_100000', false)
end
