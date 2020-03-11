rand_TPMS = {};

for i = 1:10
    rand_TPMS{i} = rand(4,2);
end

%% generate datasets
N_BITS = 10^6;
restricted_datasets = {};

for i = 1:10
    dataset = zeros(2, N_BITS);
    dataset(:, 1) = [1;1];    %A and B start at ON
    for j = 2:N_BITS
        previous = dataset(:, j-1);
        prev_index = bi2de(previous') + 1;
        p_flip_A_B = rand_TPMS{i}(prev_index, :);
        rand_AB = rand(1,2);
        current_vals_A_B = rand_AB < p_flip_A_B;
        dataset(:, j) = current_vals_A_B;
    end
    restricted_dataset{i} = dataset;
end
%% similar to bineural TPM
sim_bin_TPM_rest_1 = [0.2,0.2;0.93,0.3;0.3,0.93;0.8,0.8];
sim_bin_TPM_rest_2 = [0.1,0.1;0.93,0.3;0.3,0.93;0.9,0.9];
sim_bin_TPM_rest_3 = [0.05,0.05;0.93,0.3;0.3,0.93;0.95,0.95];
sim_bins = {sim_bin_TPM_rest_1,sim_bin_TPM_rest_2,sim_bin_TPM_rest_3};
for i = 1:3
sim_bin_TPM_rest = sim_bins{i};  
sim_dataset = zeros(2, N_BITS);
    sim_dataset(:, 1) = [1;1];    %A and B start at ON
    for j = 2:N_BITS
        previous = sim_dataset(:, j-1);
        prev_index = bi2de(previous') + 1;
        p_flip_A_B = sim_bin_TPM_rest(prev_index, :);
        rand_AB = rand(1,2);
        current_vals_A_B = rand_AB < p_flip_A_B;
        sim_dataset(:, j) = current_vals_A_B;
    end
end
%% run CSSR!
MAX_L = 12;
super_comps = zeros(10, MAX_L);
super_As = cell(10,MAX_L);

for i = 1:10
    f_name = strcat("restricted_TPMs_", num2str(i), "_", num2str(N_BITS));
    convert_dataset_to_textfile(restricted_dataset{i}(1, :), f_name);
    for l = 1:MAX_L
        [super_comps(i, l), super_As{i, l}] = run_CSSR_file(f_name, 'alphabet.txt', l, 0.005, false);

    end
end
%% run CSSR! on neural like data
MAX_L = 12;
super_comps_neural = zeros(1, MAX_L);
super_As_neural = cell(1,MAX_L);

f_name = strcat("neural_like_TPMs_", num2str(N_BITS));
convert_dataset_to_textfile(sim_dataset(1, :), f_name);
for l = 1:MAX_L
    [super_comps_neural(1, l), super_As_neural{1, l}] = run_CSSR_file(f_name, 'alphabet.txt', l, 0.005, false);
end
