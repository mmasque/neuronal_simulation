n_bits = 10^7;
n_neurons = 3;

data = n_neuron_simulation(n_neurons, n_bits);

%% first join the neurons into a single data stream
[joined_data, alphabet] = create_dataset_from_n_binary_sets(data);

dataset_FName = 'joined_3_neurons';
alphabet_FName = strcat('alphabet_', num2str(2^n_neurons));

convert_dataset_to_textfile(joined_data, dataset_FName);
convert_dataset_to_textfile(alphabet, alphabet_FName);

Max_L = 7;
comps = zeros(1, Max_L);
for L = 1:Max_L
    comps (1, L) = run_CSSR_file(dataset_FName, alphabet_FName, L, 0.005, false);
end


%% sampling of just 1 neuron at a time and CSSR reconstruction from just one neuron
comps_singles = zeros(3, Max_L);
for i = 1:n_neurons
    dataset_FName = strcat('single_out_of_3_N', num2str(i));
    convert_dataset_to_textfile(data(i, :), dataset_FName);
    
    Max_L = 7;
    for L = 1:Max_L
        comps_singles(i, L) = run_CSSR_file(dataset_FName, 'alphabet.txt', L, 0.005, false);
    end
end
