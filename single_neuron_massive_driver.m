
n_bits = 10^8;
n_neurons = 5;

data = n_neuron_simulation(n_neurons, n_bits);

%% sampling of just 1 neuron at a time and CSSR reconstruction from just one neuron
Max_L = 6;
comps_singles = zeros(n_neurons, Max_L);
for i = 1:n_neurons
    dataset_FName = strcat('single_out_of_5_N', num2str(i));
    convert_dataset_to_textfile(data(i, :), dataset_FName);
        for L = 1:Max_L
        comps_singles(i, L) = run_CSSR_file(dataset_FName, 'alphabet.txt', L, 0.005, false);
        end
end
