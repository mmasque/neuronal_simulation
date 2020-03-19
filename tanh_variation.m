%{ 
    
    single neuron simulation
    * neuron has a self weight of 1
    * therefore X = sum(weights, states) is either 0 or 1
    
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
state_seriess = zeros(N_BITS, numel(as), numel(ds));
for a_i = 1:numel(as)
    for d_i = 1:numel(ds)
        for i = 2:N_BITS
            % get the past state of the neuron
            X = state_seriess(i-1, a_i, d_i);
            a = as(a_i);
            d = ds(d_i);
            %calculate probability that in this state the neuron is active
            %given the activation function parameters and the past state of
            %the neuron
            p_active = d * tanh(a * X - 2) + 0.5;
            
            %simulate whether the neuron is now active or not. 
            if rand() < p_active
                % if it's active, set it to 1, otherwise it's already 0 so
                % just leave it. 
                state_seriess(i, a_i, d_i) = 1;
            end
            
        end
    end
end

%% run CSSR on all of this data.
% this'll be slow
L_range = 1:11;
comps = zeros(numel(L_range), numel(as), numel(ds));
As = cell(numel(L_range), numel(as), numel(ds));
for a_i = 2:numel(as)
    for d_i = 2:numel(ds)
        dataset_FName = strcat('single_neuron_tanh_a', num2str(a_i), '_d', num2str(d_i),'_', num2str(NUM_BITS));
        convert_dataset_to_textfile(state_seriess(:, a_i, d_i), dataset_FName);
        
        %run CSSr now that we have the data file
        for L = L_range
            [comps(L, a_i, d_i), As{L, a_i, d_i}] = run_CSSR_file(dataset_FName, 'alphabet.txt', L, 0.005, false);
        end
    end
end

