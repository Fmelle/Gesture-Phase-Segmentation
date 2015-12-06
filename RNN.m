% Solve an Input-Output Time-Series Problem with a Time Delay Neural Network
% Script generated by Neural Time Series app.
% Created 05-Dec-2015 21:14:24
%
% This script assumes these variables are defined:
%
%   inputs - input time series.
%   labelsProcessed - target time series.

load('numContainer');
load('txtContainer');

labelsProcessed = txtProcessedData{1};
labelsProcessed = double(cell2mat(labelsProcessed));
labelsProcessed(labelsProcessed == 'D') = 1; % rest
labelsProcessed(labelsProcessed == 'P') = 2; % preparation
labelsProcessed(labelsProcessed == 'S') = 3; % stroke
labelsProcessed(labelsProcessed == 'H') = 4; % hold
labelsProcessed(labelsProcessed == 'R') = 5; % retraction

% Solving the Classification Problem with a Neural Network
labelsProcessed = labelsProcessed';
inputs = numProcessedData{1}(:,:)';

X = tonndata(inputs,true,false);
T = tonndata(labelsProcessed,true,false);

% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
trainFcn = 'trainlm';  % Levenberg-Marquardt backpropagation.

% Create a Time Delay Network
inputDelays = 1:20;
hiddenLayerSize = 10;
net = timedelaynet(inputDelays,hiddenLayerSize,trainFcn);

% Prepare the Data for Training and Simulation
% The function PREPARETS prepares timeseries data for a particular network,
% shifting time by the minimum amount to fill input states and layer
% states. Using PREPARETS allows you to keep your original time series data
% unchanged, while easily customizing it for networks with differing
% numbers of delays, with open loop or closed loop feedback modes.
[x,xi,ai,t] = preparets(net,X,T);

% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% Train the Network
[net,tr] = train(net,x,t,xi,ai);

% Test the Network
y = net(x,xi,ai);
e = gsubtract(t,y);
performance = perform(net,t,y)

% View the Network
view(net)

% Plots
% Uncomment these lines to enable various plots.
%figure, plotperform(tr)
%figure, plottrainstate(tr)
%figure, ploterrhist(e)
%figure, plotregression(t,y)
%figure, plotresponse(t,y)
%figure, ploterrcorr(e)
%figure, plotinerrcorr(x,e)

% Step-Ahead Prediction Network
% For some applications it helps to get the prediction a timestep early.
% The original network returns predicted y(t+1) at the same time it is
% given x(t+1). For some applications such as decision making, it would
% help to have predicted y(t+1) once x(t) is available, but before the
% actual y(t+1) occurs. The network can be made to return its output a
% timestep early by removing one delay so that its minimal tap delay is now
% 0 instead of 1. The new network returns the same outputs as the original
% network, but outputs are shifted left one timestep.
nets = removedelay(net);
nets.name = [net.name ' - Predict One Step Ahead'];
view(nets)
[xs,xis,ais,ts] = preparets(nets,X,T);
ys = nets(xs,xis,ais);
stepAheadPerformance = perform(nets,ts,ys);

labelsProcessed2 = txtProcessedData{2};
labelsProcessed2 = double(cell2mat(labelsProcessed2));
labelsProcessed2(labelsProcessed2 == 'D') = 1; % rest
labelsProcessed2(labelsProcessed2 == 'P') = 2; % preparation
labelsProcessed2(labelsProcessed2 == 'S') = 3; % stroke
labelsProcessed2(labelsProcessed2 == 'H') = 4; % hold
labelsProcessed2(labelsProcessed2 == 'R') = 5; % retraction

% Solving the Classification Problem with a Neural Network
labelsProcessed = labelsProcessed';
testinputs = numProcessedData{2}(:,:)';

testinputs = testinputs'; testinputCell = {};
for i = 1:size(testinputs,1)
    testinputCell = [testinputCell;testinputs(i,:)'];
end

testresults = nets(testinputCell',xis,ais)

testresults = round(cell2mat(nets(testinputCell',xis,ais)));
sum(testresults' ~= labelsProcessed2) / length(testresults)