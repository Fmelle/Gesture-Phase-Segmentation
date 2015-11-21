function knn_accuracy( K, rloss, cvloss, icvlossmin, distanceMetric )
    % This function returns plots showing in-sample and out-of-sample
    % accuracies as functions of the number of neigbours.
    
    figure; 
    semilogx(K,rloss,'g.-');
    hold on
    semilogx(K,cvloss,'b.-');
    plot(K(icvlossmin),cvloss(icvlossmin),'ro')
    xlabel('Number of Nearest Neighbors');
    ylabel('Ten-fold Classification Error');
    legend('In-sample','Out-of-sample','Optimum','Location','Best')
    title(strcat(strcat('KNN Classification using the ', ...
        distanceMetric), ' Distance Metric'));

end