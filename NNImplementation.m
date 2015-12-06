%% Neural Network Solution

% Loading the data.
[numProcessedData, txtProcessedData, rawprocessedData] = ...
    load_data('data_files/processed/', 'data_files/processed/*.csv');

labelsProcessed = txtProcessedData{1};
labelsProcessed = double(cell2mat(labelsProcessed));
labelsProcessed(labelsProcessed == 'D') = 1; % rest
labelsProcessed(labelsProcessed == 'P') = 2; % preparation
labelsProcessed(labelsProcessed == 'S') = 3; % stroke
labelsProcessed(labelsProcessed == 'H') = 4; % hold
labelsProcessed(labelsProcessed == 'R') = 5; % retraction

% Solving the Classification Problem with a Neural Network
inputs = numProcessedData{1}(:,:);
targets = labelsProcessed';

% Creating a Pattern Recognition Network.
hiddenLayerSize = 10;
net = patternnet(hiddenLayerSize);

% Dividing the Training Data into Training, Validation and Testing datasets
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% Training the Network.
[net,tr] = train(net,inputs,targets);

% Testing the Network.
outputs = net(inputs);
errors = gsubtract(targets,outputs);
performance = perform(net,targets,outputs);

% Generaing a set of Predictions for the test data.
nnPredictions = sim(net, numProcessedData{2}(:,:));

% Transposing the results.
nnPredictions = nnPredictions';