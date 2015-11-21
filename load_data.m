function [numContainer, txtContainer, rawContainer] = ...
    load_data( directory, dir_ext )

    % This function reads in the data files perinent to the gesture phases and
    % extracts the explanatory variables and associated labels.  

    % Creating a structure to store the Processed Data files.
    numContainer = struct([]);
    txtContainer = struct([]);
    rawContainer = struct([]);
    srcFiles = dir(dir_ext);
    for i = 1 : length(srcFiles)
        filename = strcat(directory,srcFiles(i).name);
        [num, txt, raw] = xlsread(filename);
        numContainer{i} = num(2:end,:);
        txtContainer{i} = txt(2:end,:);
        rawContainer{i} = raw(2:end,:);
    end
    
    % Saving the data to mat files.
    save('numContainer.mat','numContainer');
    save('txtContainer.mat','txtContainer');
    save('rawContainer.mat','rawContainer');
end