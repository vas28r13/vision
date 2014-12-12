function [model] = train_svm(train_features, train_labels)

x = train_features;
y = train_labels;

model = svmtrain(y, x, '-t 2 -c 16 -g 1');