%{ 
    
    two neuron simulation
    
    * activation function is tanh:  
        * Act_Func = d * tanh(ax + b) + c
            b = -2
            c = 0.5
            0 <= d <= 0.5 (forced)
            1 <= a <= 5 (arbitrary)

    
%}

%% generate data with varying d and a
as = 0:5;
ds = 0:0.1:0.5;
N_BITS = 10^6;
%%
state_seriess = zeros(2, N_BITS, numel(as), numel(ds));
weight_matrix = [1, 0.25;0.25, 1];
for a_i = 2:numel(as)
    for d_i = 2:numel(ds)
        for i = 2:N_BITS
            % get the past state of the neurons
            X = state_seriess(:, i-1, a_i, d_i);
            % multiply by the weight transformation matrix to get the sum
            % of weight * State for each neuron
            weighted_X = weight_matrix * X;
            a = as(a_i);
            d = ds(d_i);
            %calculate probability that in this state the neurons are active
            %given the activation function parameters and the past state of
            %the neurons
            p_active = d * tanh(a * weighted_X - 2) + 0.5;
            
            % simulate whether each neuron is now active or not. 
           
            rand_vals = rand(2,1);
            state_seriess(:,i, a_i, d_i) = ~(rand_vals < p_active);
            
            
        end
    end
end

%% run CSSR on all of this data.
% this'll be slow
L_range = 1:11;
comps = zeros(numel(L_range), 1, numel(ds));
As = cell(numel(L_range), 1, numel(ds));
for a_i = 3%2:numel(as)
    for d_i = 2:numel(ds)
        dataset_FName = strcat('two_neurons_tanh_a', num2str(a_i), '_d', num2str(d_i),'_', num2str(N_BITS));
        convert_dataset_to_textfile(state_seriess(1, :, a_i, d_i), dataset_FName);
        
        %run CSSr now that we have the data file
        for L = L_range
            [comps(L, 1, d_i), As{L, 1, d_i}] = run_CSSR_file(dataset_FName, 'alphabet.txt', L, 0.005, false);
        end
    end
end

