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
%system(num2str(s))
info_fname = strcat(dataset_FName, "_info");
A = readmatrix(info_fname, "Delimiter", ":");
complexity = A(8, 2);
end