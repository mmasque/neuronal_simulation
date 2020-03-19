function [data] = n_neuron_simulation(n_neurons, n_bits, mult_out, mult_in, add_out, add_in)
%{
This function simulates the behaviour of a single line of interconnected
binary neurons. It 
n_neurons = 5; 
n_bits = 10^3;
mult_out = 0.4;
mult_in = 3;
add_out = 0.5;
add_in = -2;
%}
% construct weight transition matrix, very lazy implementation
wtm = zeros(n_neurons, n_neurons);
for i = 1:n_neurons
    wtm(i,i) = 1;
    try wtm(i, i + 1) = 0.25;    end
    try wtm(i, i - 1) = 0.25;   end     
end
wtm = wtm(1:n, 1:n);


% generate some data
data = zeros(n_neurons, n_bits);

%using tanh
for i = 2:n_bits
    previous = data(:, i-1);
    xes = wtm * previous + noise_c;
    tanh_data = mult_out * tanh(mult_in * xes + add_in) + add_out;
    rand_n = rand(n,1);
    curr = rand_n < tanh_data;
    data(:, i) = curr;
end

return data;