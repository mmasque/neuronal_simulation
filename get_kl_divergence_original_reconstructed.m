function [results] = get_kl_divergence_original_reconstructed(FName)

    A = readmatrix(FName, "Delimiter", ":");
    results = A(6:8, 2)
end

