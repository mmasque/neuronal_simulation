function [complexity, A] = run_CSSR_file(dataset_FName, alphabet_FName, L_Max, s, multiline)
%{
    run command prompt version of CSSR through MatLab directly.
    Usage: 
        
        - in a terminal, type 'make' in the directory cpp Makefile is stored.
        - 'cp' the resuting CSSR exe file into your path (on a mac this is
        'usr/local/bin') 
        - ensure run_CSSR.m and convert_dataset_to_textfile.m are in your
        MATLAB path (right-click on the folder they are in and select add to
        path)
        - set your MATLAB current folder to the folder containing the
        alphabet file. 
        - call run_CSSR with the appropriate arguments
        

    arguments:
        dataset: epochs x timestamp double, where each epoch is a trial to
        be considered independently.
        
        alphabet_FName: a string of the file name of the alphabet to use. 
                        if using a binary alphabet, "binary01-alphabet.txt"
                        can be used. 
        L_Max: num - maximum memory length
        s: float - significance level
        output_FName: the name all output files should start with. Do not
        include type extension.
        multiline: bool

    outputs:
        complexity: double - statistical complexity of the system
        
        for file outputs, see README
%}
%alpha set to 0.005
if multiline
    call_CSSR = strcat("./CSSR ", alphabet_FName, " ", dataset_FName, " ",...
    num2str(L_Max), " -m -s ", num2str(s));
else
    call_CSSR = strcat("./CSSR ", alphabet_FName, " ", dataset_FName, " ",...
    num2str(L_Max), " -s ", num2str(s));
    disp('hello');
end
system(call_CSSR);

% rename files with L so they are not replaced.
with_info = strcat(dataset_FName, '_info');
with_info_l = strcat(with_info, "_", num2str(L_Max));
change_name = strcat("cp ", with_info," ", with_info_l);
system(change_name);

with_results = strcat(dataset_FName, '_results');
with_results_l = strcat(with_results, "_", num2str(L_Max));
change_name = strcat("cp ", with_results," ", with_results_l);
system(change_name);

with_state_series = strcat(dataset_FName, '_state_series');
with_state_series_l = strcat(with_state_series, "_", num2str(L_Max));
change_name = strcat("cp ", with_state_series," ", with_state_series_l);
system(change_name);

with_dot = strcat(dataset_FName, '_inf.dot');
with_dot_l = strcat(dataset_FName, "_", num2str(L_Max), '_inf.dot');
change_name = strcat("cp ", with_dot," ", with_dot_l);
system(change_name);

%system(num2str(s))
info_fname = strcat(dataset_FName, "_info");
A = readmatrix(info_fname, "Delimiter", ":");
complexity = A(8, 2);
end