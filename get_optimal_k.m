function [ kOptimal, K, rloss, cvloss, icvlossmin ] = ...
    get_optimal_k( trainData,trainLabels, distMetric )
    % Performance of the KNN classifier versus number of neighbors using
    % a selected Distance Metric.
    [N,D] = size(trainData);
    K = round(logspace(0, log10(N), 10)); % Number of Neighbors
    cvloss = zeros(length(K),1);
    for k=1:length(K)
        % Constructing a cross-validated classification model
        mdl = fitcknn(trainData, trainLabels, 'Distance', distMetric, ...
        'NumNeighbors', K(k));
        % Calculating the in-sample loss (Resubstitution Loss)
        rloss(k)  = resubLoss(mdl);
        % Constructing a cross-validated classifier from the model.
        cvmdl = crossval(mdl);
        % Examining the cross-validation loss, which is the average loss of 
        % each cross-validation model when predicting on data that is not
        % used for training.
        cvloss(k) = kfoldLoss(cvmdl);
    end
    [~,icvlossmin] = min(cvloss);
    kOptimal = K(icvlossmin);
    
end