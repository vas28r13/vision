function [train_hists, train_labels] = build_training_histograms(feat_dir, file_array, clusters, map)

% @param - feat_dir    :  directory that contains features
% @param - file_array  :  array of folder names that contain feature files
% @param - clusters    :  clusters for building histograms (bag of words)
% @param - map         :  hashtable for string label to number label

disp(['Feature dir: ' feat_dir]);

train_hists = [];
train_labels = [];
hists_count = 1;

for i = 1:length(file_array)
    feat_folder_name = file_array(i);
    full_dir = strcat(feat_dir, '/', feat_folder_name);
    full_dir = full_dir{1,1};
    
    disp(['Preprocessing folder: ' full_dir]);
    
    feat_files = dir(full_dir);
    
    
    for j = 1:length(feat_files)
        feat_file = feat_files(j);
        if (strcmp(feat_file.name, '.') || strcmp(feat_file.name, '..') || strcmp(feat_file.name, '.DS_Store'))
            continue;
        end
        
        full_path = [full_dir, '/', feat_file.name];
        %disp(['Preprocessing features: ' full_path]);
        
        %build cluster histograms from features
        try
            histogram = get_histograms(clusters, full_path);
            train_hists(hists_count, :) = histogram;

            %make sure the label is correct
            [my_dir, name, ext] = fileparts(full_path);
            name_array = regexp(name, '_', 'split');
            label_name = [name_array{4}];
            dyad_num = [name_array{1}];

            train_labels(hists_count, 1) = str2num(dyad_num);
            train_labels(hists_count, 2) = map(label_name);

            hists_count = hists_count + 1;
        catch err
            disp(['Could not get histogram from: ' full_path]);
            disp(err);
        end
            
    end
    
end

save training.mat train_hists train_labels