function [data] = n_neuron_simulation(n_neurons, n_bits, mult_out, mult_in, add_out, add_in)
%{
This function simulates the behaviour of a single line of interconnected
binary neurons. A neuron's next state is determined using tanh as an 
activation function which takes inputs of the previous state of 
the neuron itself and of the states of the two (or one if at edge)
neurons next to it. 

See A Haun, G Tononi - Entropy, 2019 for more on the structure 
(uses a different activation function) 


The tanh function: 
    Y = mult_out * tanh(mult_in * X + add_in) + add_out

Default tanh Parameters: 
    mult_out = 0.4;
    mult_in = 3;
    add_out = 0.5;
    add_in = -2;

Inputs: 
    n_neurons: {integer} - the number of neurons 
    n_bits: {integer} - the number of bits to simulate for each neuron
    rest of inputs are optional {real number} parameters of the tanh function above

Outputs: 
    data: {n_neurons x n_bits double} - the state of each neuron over the
    n_bits of time. 

%}
% check compulsory parameters
if (nargin < 2)
    error("n_neurons and n_bits are required inputs");
end
% check optional parameters
if (~exist('mult_out', 'var')) mult_out = 0.4; end
if (~exist('mult_in', 'var')) mult_in = 3; end
if (~exist('add_out', 'var')) add_out = 0.5; end
if (~exist('add_in', 'var')) add_in = -2; end

disp(mult_out)
disp(mult_in)
disp(add_out)
disp(add_in)
% construct weight transition matrix, very lazy implementation
wtm = zeros(n_neurons, n_neurons);
for i = 1:n_neurons
    wtm(i,i) = 1;
    try wtm(i, i + 1) = 0.25;    end
    try wtm(i, i - 1) = 0.25;   end     
end
wtm = wtm(1:n_neurons, 1:n_neurons);

data = zeros(n_neurons, n_bits);

%using tanh, generate the data of all the neurons.
for i = 2:n_bits
    previous = data(:, i-1);
    xes = wtm * previous;
    tanh_data = mult_out * tanh(mult_in * xes + add_in) + add_out;
    rand_n = rand(n_neurons,1);
    curr = rand_n < tanh_data;
    data(:, i) = curr;
end