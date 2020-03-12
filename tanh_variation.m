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