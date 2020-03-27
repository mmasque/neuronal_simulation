%% run CSSR on all the neuroons
Max_L = 7;
comps = zeros(1, Max_L);
alphabet_FName = 'alphabet_8';
dataset_FName = 'joined_3_neurons';

parfor L = 1:Max_L
    comps (1, L) = run_CSSR_file(dataset_FName, alphabet_FName, L, 0.005, false);
end
