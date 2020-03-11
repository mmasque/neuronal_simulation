%% constants
N_BITS = 10^6;
FNAME = strcat("test_two_types_", num2str(N_BITS));

%% system 1
        % 0    1
% probability of spitting out a 1 given states of A and B
             % A B
TPM_1A =[0.1;% 0 0
         0.5;% 1 0
         0.5;% 0 1
         0.9];% 1 1

     
             % A B
TPM_1B =[0.1;% 0 0
         0.5;% 1 0
         0.5;% 0 1
         0.9];% 1 1
% generate
dseries_1 = zeros(2, N_BITS);
for i = 2:N_BITS
    prev = dseries_1(:, i-1);
    ind = bi2de(prev') + 1;

    % A
    prob_A = TPM_1A(ind);
    % B
    prob_B = TPM_1B(ind);

    vals = rand(size(prev)) < [prob_A; prob_B];
    dseries_1(:, i) = vals;
end
%% system 2

                % A B
TPM_2A = [0.1;  % 0 0
          0.7;  % 1 0
          0.4; % 0 1
          0.99]; % 1 1

TPM_2B = [0.1;
          0.4;
          0.7;
          0.99];

% generate
dseries_2 = zeros(2, N_BITS);
for i = 2:N_BITS
    prev = dseries_2(:, i-1);
    ind = bi2de(prev') + 1;

    % A
    prob_A = TPM_2A(ind);
    % B
    prob_B = TPM_2B(ind);

    vals = rand(size(prev)) < [prob_A; prob_B];
    dseries_2(:, i) = vals;
end      

%% CSSRing
first_name = strcat(FNAME, "_first");
second_name = strcat(FNAME, "_second");

first_name = strcat(first_name, num2str(NUM_BITS));
convert_dataset_to_textfile(dseries_1(1, :), first_name);

second_name = strcat(second_name, num2str(NUM_BITS));
convert_dataset_to_textfile(dseries_2(1, :), second_name);
%%
comps = zeros(3, 20);
for i = 1:20
    
    
    %comps(1, i) = run_CSSR_file(first_name,  'alphabet.txt', i, 0.005, false);
    comps(2, i) = run_CSSR_file(second_name,  'alphabet.txt', i, 0.000005, false);


end

