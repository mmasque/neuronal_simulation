MAXL = 6;
%system('bash transition_grab.sh')
gradKL_o_r = zeros(10, 6); %initialize
gradKL_r_o = zeros(10,6);
gradKL_symm_f_r = zeros(10,6);


for neuron = 1:10
    for memlength = 2:MAXL
        originalfname = strcat('single_out_of_10_N', num2str(neuron));
        %%%%%% get the inputs %%%%%%
        T0 = (readmatrix(strcat('trans0_single_out_of_10_N', num2str(neuron), '_', num2str(memlength))));
        T1 = (readmatrix(strcat('trans1_single_out_of_10_N', num2str(neuron), '_', num2str(memlength))));
        Tgen = (cat(3, T0, T1));
        init = (readmatrix(strcat('inipi_single_out_of_10_N', num2str(neuron), '_', num2str(memlength)))');
        for n = 1 + MAXL:2 + MAXL
            sequence = (dec2bin(2^n-1:-1:0)-'0')+1; % 2^n rows, n columns each row is one possible observable sequence. 1 is a 0, 2 is a 1 lol
            reconstructed_Pro = zeros(2^n,1);
            original_Pro = zeros(2^n, 1);
            for k = 1:2^n
                reconstructed_Pro(k,1) = fa_hmm(sequence(k,:),Tgen,init); %runs Forward algorithm on all possible sequences, creating a column vector with length 2^n
                % get a string of the sequence
                strsequence = num2str(sequence(k, :) -1);
                strsequence = strsequence(~isspace(strsequence));
                original_Pro(k,1) = get_probability_of_sequence(originalfname, strsequence);
            end
            % original vs reconstructed KL
            kldummy = original_Pro.*log2(original_Pro./reconstructed_Pro); % P = original, Q reverse            
            % reconstructed vs original KL
            qpdummy = reconstructed_Pro.*log2(reconstructed_Pro./original_Pro); % opposite to above
            
            %kldummy(isnan(kldummy))=0; %sets NaN values due to 0*log(0/Q) to =0
            %kldummy(kldummy == Inf)=0; %sets Inf values due to P*log(P/0) to =0
            %qpdummy(isnan(qpdummy))=0; %sets NaN values due to 0*log(0/Q) to =0
            %qpdummy(qpdummy == Inf)=0; %sets Inf values due to P*log(P/0) to =0
            
            dummy_KL_o_r(n-MAXL) = sum(kldummy); % KL(P|Q)
            dummy_KL_r_o(n-MAXL) = sum(qpdummy); % KL(Q|P)
            clear kldummy qpdummy k sequence
            
          
        end
        gradKL_o_r(neuron, memlength) = dummy_KL_o_r(2) - dummy_KL_o_r(1); % n13 - n12 for gradient
        gradKL_r_o(neuron, memlength) = dummy_KL_r_o(2) - dummy_KL_r_o(1);
        gradKL_symm_f_r(neuron, memlength) = gradKL_o_r(neuron, memlength) + gradKL_r_o(neuron, memlength);
        clear dummy_KL_f_r dummy_KL_r_f n
    end
end