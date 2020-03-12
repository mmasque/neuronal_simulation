%% plot the sigmoid
states = [0,0;0,1;1,0;1,1];
weights = [1, 0.25;
           0.25, 1];
prob_sum = states * weights;
prob_sum_w_noise = prob_sum + mu;
state_probs = ((prob_sum).^n)./(z + (prob_sum).^n);
state_probs_w_noise = ((prob_sum_w_noise).^n)./(z + (prob_sum_w_noise).^n);
hold on;
plot(prob_sum(:,1), state_probs(:,1));
plot(prob_sum_w_noise(:, 1), state_probs_w_noise(:,1));
%% initialise the states

states = [1, 1];

weights = [1, 0.25;
           0.25, 1];

% Naka-Rushton sigmoid constants, as chosen by Haun & Tononi 2019 Entropy
n = 5;
z = 1/4;

% computing the probability that each state will be ON given the past
% state. 
prob_sum = states * weights;

% add a gaussian so the system doesn't die. 
mu = 0.4;   %don't want this to be < 0.
sigma = 0.1;
gauss_noise = normrnd(mu, sigma, 1, 2);
prob_sum = prob_sum + gauss_noise;

state_probs = ((prob_sum).^n)./(z + (prob_sum).^n);

% generate data. 
NUM_BITS = 100000;
dset_states = zeros(2, NUM_BITS+1);
dset_states(:, 1) = states;
dset_probs = zeros(2, NUM_BITS+1);
dset_probs(:, 1) = state_probs;
for b = 1:NUM_BITS
    
    % update the current states
    states = rand(size(state_probs)) < state_probs;
    
    % append to the dataset
    dset_states(:, b) = states;
    % also append the probabilities
    dset_probs(:, b) = state_probs;
    % add the noise state 
    % update state_probs
    prob_sum = states * weights;
    % add the gaussian kickstarter
    gauss_noise = normrnd(mu, sigma, 1, 2);
    prob_sum = prob_sum + gauss_noise;

    state_probs = ((prob_sum).^n)./(z + (prob_sum).^n);

    
end
%% do some CSSRing
comps = zeros(1, 16);
A = cell(1, 16);
dataset_FName = strcat('two_neurons_gauss_noise_sec', num2str(NUM_BITS));
convert_dataset_to_textfile(dset_states(1,1:NUM_BITS), dataset_FName);
%%
for i = 1:8
    [comps(i), A{1, i}] = run_CSSR_file(dataset_FName, 'alphabet.txt', i, 0.005, false);

end
   

%% join the datasets
states_weighted = [dset_states(1, :) * 2; dset_states(2, :)];
states_joined = sum(states_weighted);

%% do some CSSring on the joined dataset
comps = zeros(1, 16);
A = cell(1, 16);
dataset_FName = strcat('both_neurons_gauss_', num2str(NUM_BITS));
convert_dataset_to_textfile(states_joined(1:NUM_BITS), dataset_FName);
%%
for i = 1:16
    [comps(1, i), A{1, i}] = run_CSSR_file(dataset_FName, 'alphabet4.txt', i, 0.005, false);
        
end
