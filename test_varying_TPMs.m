% rng(1); % for reproducibility
N_BITS = 10^7;
simulations = zeros(10, N_BITS);
mcs = cell(1, 10);
for i = 1:10
    mc = mcmix(4);
    mcs{1, i} = mc.P;
    chain = simulate(mc, N_BITS-1);
    chain(chain <= 2) = 0;
    chain(chain > 2) = 1;
    simulations(i, :) = chain';
end

%% simulate neuron
TPM_Neuron = [
            0.9*0.9, 0.9*0.1, 0.1*0.9, 0.1*0.1;
            0.8*0.05,0.8*0.95,0.2*0.05,0.2*0.95;
            0.05*0.8,0.05*0.2,0.95*0.8,0.95*0.2;
            0.01*0.01,0.01*0.99,0.99*0.01, 0.99*0.99];
mc = dtmc(TPM_Neuron);
neuron_sim = simulate(mc, N_BITS-1);
neuron_sim(neuron_sim <= 2) = 0;
neuron_sim(neuron_sim > 2) = 1;
f_name = strcat("varying_TPMs_", "neuronal_", num2str(N_BITS));
convert_dataset_to_textfile(neuron_sim, f_name);
comps = []
for i = 1:14
    [comp, a] = run_CSSR_file(f_name, 'alphabet.txt', i, 0.005, false);
    comps = [comps comp];
end
%% do some CSSRing
MAX_L = 12;
super_comps = zeros(10, MAX_L);
super_As = cell(10,MAX_L);
for i = 1:10
    f_name = strcat("varying_TPMs_", num2str(i), "_", num2str(N_BITS));
    convert_dataset_to_textfile(simulations(i, :), f_name);
    
    for j = 1:MAX_L
        [super_comps(i, j), super_As{i, j}] = run_CSSR_file(f_name, 'alphabet.txt', j, 0.005, false);
    end
    
end