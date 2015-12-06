%{
Author(s): Omar Syed & Paul Buchana
E-Mail(s): osyed@andrew.cmu.edu & pbuchana@andrew.cmu.edu
Last Modified: 11/28/2015
%}

tic

[numProcessedData, txtProcessedData, rawprocessedData] = ...
    load_data('data_files/processed/', 'data_files/processed/*.csv');

data = {numProcessedData{1}(:,end), txtProcessedData{1}};

computationTime = toc;
fprintf('Computaion Time: %f \n', computationTime);