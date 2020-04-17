function p = get_probability_of_sequence(textfile, strpattern)
    wholestring = fileread(textfile);
    k = length(strfind(wholestring, strpattern));
    total = length(wholestring) - length(strpattern) + 1;
    p =  k/total;
end