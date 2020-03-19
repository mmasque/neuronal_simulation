p_on_1a = [0.3 0.3;0.32 0.6;0.6 0.32;0.62 0.62];
p_on_1b = [0.05 0.05;0.07 0.95; 0.95 0.07; 0.97 0.97];
p_on_2a = [0.25 0.25;0.35 0.55;0.55 0.35; 0.65 0.65];
p_on_2b = [0.05 0.05;0.15 0.85;0.85 0.15;0.95 0.95];

arr_of_ps = cat(3, p_on_1a,p_on_1b,p_on_2a,p_on_2b);
N_BITS = 10^6;
%% generate some data
data = zeros(4,2,N_BITS);
for i = 1:4
    for j = 2:N_BITS
        curr = data(i, :, j-1);
        index = (2*curr(1) + curr(2)) + 1;
        prob = arr_of_ps(index, :,i);
        r = rand(1,2);
        data(i, :, j) = prob > r;
    end
end
%% run CSSR! on neural like data
MAX_L = 12;
super_comps_neural = zeros(4, MAX_L);
super_As_neural = cell(4,MAX_L);
for i = 1:4
    f_name = strcat("neural_like_TPMs_n",num2str(i), "_", num2str(N_BITS));
    convert_dataset_to_textfile(data(i,1, :), f_name);
    for l = 1:MAX_L
        [super_comps_neural(i, l), super_As_neural{i, l}] = run_CSSR_file(f_name, 'alphabet.txt', l, 0.005, false);
    end
end


%% get TPMS and generate data

% first get the TPM and generate data
% will do length 7 of 1 vs 2 vs 3 vs 4
TPMS = cell(1,4);
TLMS = cell(1,4);
simmed_data = cell(4, 1);
for i = 1:4
    [TPMS{i}, TLMS{i}] = get_TPM_and_emissions_from_dot(strcat('neural_like_TPMS_n', num2str(i), '_1000000_7_inf.dot'));
    TPMS{i}(isnan(TPMS{i})) = 0;
    simmed_data(i) = generate_bistable_binary_data(N_BITS-1, dtmc(TPMS{i}), TLMS{i}, false);
end


%% KL stuff
