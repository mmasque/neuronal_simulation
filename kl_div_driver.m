kl_and_rate = zeros(3, 6, 3);
for i = 1:10
    for j = 1:6
        fname = strcat("single_out_of_10_N", num2str(i), "_info_", num2str(j));
        kl_and_rate(i, j, :) = get_kl_divergence_original_reconstructed(fname);
    end
end




kl = kl_and_rate(:, :, 1)';
cmap = jet(10);
for k = 1:10
  line(1:6,kl(:, k), 'Color', cmap(k, :));
end
xlabel("Memory length L")
ylabel("KL Divergence")
title({"KL Divergence as L increases," "for each of 10 neurons in a connected network"})
legend(num2str((1:10)'));
figure;

klrate = kl_and_rate(:, :, 2)'
cmap = jet(10);
for k = 1:10
  line(1:6,klrate(:, k), 'Color', cmap(k, :));
end
ylabel("KL Divergence Rate")
xlabel("Memory length L")
title({"KL Divergence Rate as L increases", "for each of 10 neurons in a connected network"})
legend(num2str((1:10)'));
figure;

comps = kl_and_rate(:, :, 3)'
cmap = jet(10);
for k = 1:10
  line(1:6,comps(:, k), 'Color', cmap(k, :));
end
ylabel("Statistical Complexity Cu")
xlabel("Memory length L")
title({"Cu as L increases", "for each of 10 neurons in a connected network"})
legend(num2str((1:10)'));


