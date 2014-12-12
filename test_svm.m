function [compare] = test_svm(labels, data, model)

[pred_labels ,err,predictions] = svmpredict(labels, data, model);

compare = [pred_labels labels]; 
% draw precision-recall curve
figure(2), clf
[rec,prec,ap,sortind]=precisionrecall(predictions,labels);
fprintf(' -> Average Precision for : %1.3f\n\n', ap)