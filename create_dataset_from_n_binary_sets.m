function [dataset, alphabet] = create_dataset_from_n_binary_sets(dsets)
    % creates a 2^nary set from n binary datasets.
    % first_dimension is binary_set n (channel)
    % second is timestamp.   
    alphabet = 0:(2^size(dsets, 1)) - 1;
    dataset = dsets(1, :);
    multiplier = 2;
    for i = 2:size(dsets, 1)
    dataset = dataset + multiplier * dsets(i, :);
    multiplier = multiplier * multiplier;
    end
    
end