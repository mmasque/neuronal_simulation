function [kldr] = KLDR(emachine_fname, original_data, maxl)
    %I'll add documentation later
    
    %first we need to get stationary and tpm distributions of the machines
    
    %then we use Aidan's forward algorithm to get the probability
    %distributions of the e-machine strings. 
    
    %then we do a similar thing for the original data, but I think we'll
    %need our own code for that.
    
    % once we have that we can just do kl divergence
    
    %to get kl divergence rate we repeat everything for 1 and 2 higher than
    %maxl and subtract one from the other.
end
