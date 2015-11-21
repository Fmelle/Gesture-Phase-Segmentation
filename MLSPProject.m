%{
Author(s): Omar Syed & Paul Buchana
E-Mail(s): osyed@andrew.cmu.edu & pbuchana@andrew.cmu.edu
Last Modified: 11/28/2015
%}

tic

% Clearing active console, closing all figures and removing historical list
% of commands.
clear ALL; close ALL; clc;

% Number iterations for AdaBoost.
distMetric = 'Enter the KNN distance Metric in string format: ';
distMetric = input(distMetric);

% Loading the processed data.
if(exist('numContainer.mat','file') && exist('rawContainer.mat','file') ...
        && exist('txtContainer.mat','file'))
    load('numContainer.mat');
    load('rawContainer.mat');
    load('txtContainer.mat');
    numProcessedData = numContainer;
    txtProcessedData = txtContainer;
    rawprocessedData = rawContainer;
else
    [numProcessedData, txtProcessedData, rawprocessedData] = ...
        load_data('data_files/processed/', 'data_files/processed/*.csv');
end

% Combining all the explanatory variables in the processed files.
explanatoryVariablesProcessed = [];
for i = 1:length(numProcessedData)
    explanatoryVariablesProcessed = [explanatoryVariablesProcessed; ...
        numProcessedData{i}];
end 

% Combining all the labels variables in the processed files.
labelsProcessed = [];
for i = 1:length(txtProcessedData)
    labelsProcessed = [labelsProcessed; txtProcessedData{i}];
end
labelsProcessed = double(cell2mat(labelsProcessed));
labelsProcessed(labelsProcessed == 'D') = 1; % rest
labelsProcessed(labelsProcessed == 'P') = 2; % preparation
labelsProcessed(labelsProcessed == 'S') = 3; % stroke
labelsProcessed(labelsProcessed == 'H') = 4; % hold
labelsProcessed(labelsProcessed == 'R') = 5; % retraction

allData = [explanatoryVariablesProcessed, labelsProcessed];

% Spitting the data into training and test sets.
c = cvpartition(labelsProcessed,'Holdout',.2);
trainData = allData(training(c),:);
testData = allData(test(c),:);

trainLabels = trainData(:,end);
testLabels = testData(:,end);
trainData = trainData(:,1:(end-1));
testData = testData(:,1:(end-1));

% Performing PCA as to extract orthogonal basis that best explain the data.
[coeff, score, latent, ~, explained] = pca([trainData;testData]);
trainScores = score(1:(size(trainData,1)),1:8);
testScores = score( (size(trainData,1) + 1) : end, 1:8);

% Establishing the optimal number of neighbours for the KNN classifier.
[ kOptimal, K, rloss, cvloss, icvlossmin ] = get_optimal_k(trainScores, ...
    trainLabels, distMetric);

% Building a KNN classifier using the optimal number of neighbours.
mdl = fitcknn(trainScores, trainLabels, 'Distance', distMetric, ...
        'NumNeighbors', kOptimal);

% Plot showing in-sample and out-of-sample accuracies as functions of the
% number of neigbours.
knn_accuracy( K, rloss, cvloss, icvlossmin, distMetric )   

fprintf('The total accuracy is: %f \n', sum(predict(mdl, testScores)== ...
    testLabels)/length(testLabels))

computationTime = toc;
fprintf('Computaion Time: %f \n', computationTime);