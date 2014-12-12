function [training_data, labels] = get_binary_classifier(training_set, label_mapping, label)

% @param - training_set  :  array of .mat files that contain training data
% for specific dyads.

% @param - label         :  label representing the binary classification

training_data = [];
labels = [];

for i = 1:length(training_set)
    dyad_set = training_set(i);
    dyad_set = dyad_set{1,1};
    load(dyad_set);
    
    label_num = label_mapping(label);
    
    for j = 1:length(train_labels)
        if train_labels(j, 2) == label_num
            labels = [labels ; 1];
        else
            labels = [labels ; -1];
        end
    end
    
    training_data = [training_data ; train_hists];
    
end