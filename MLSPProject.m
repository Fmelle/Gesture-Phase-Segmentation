%{
Author(s): Omar Syed, Fridtjof Melle & Paul Buchana
E-Mail(s): osyed@andrew.cmu.edu, fmelle@andrew.cmu.edu & 
% pbuchana@andrew.cmu.edu
Last Modified: 11/28/2015
%}

tic

% Clearing active console, closing all figures and removing historical list
% of commands.
clear ALL; close ALL; clc;

% Creating a structure to store the Processed Data files.
fileContainer = struct([]);
srcFiles = dir('data_files\*.csv');
for i = 1 : length(srcFiles)
    filename = strcat('data_files\',srcFiles(i).name);
    file = xlsread(filename);
    fileContainer{i} = file;
end

computationTime = toc;
fprintf('Computaion Time: %f \n', computationTime);