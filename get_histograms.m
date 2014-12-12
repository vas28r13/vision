function [my_histogram] = get_histograms(clusters, features_file)

% @param - clusters       : clusters of features represented by a matrix
% @param - features_file  : directory of file that contains features

disp(['Getting featurse from: ' features_file]);
[num_of_clusters, num_of_desc] = size(clusters);

disp(['Number of clusters: ', num2str(num_of_clusters)]);
disp(['Number of descriptors: ', num2str(num_of_desc)]);

features = [];
row_num = 1;

fid = fopen(features_file);
tline = fgetl(fid);

while ischar(tline)
    a = regexp(tline,'\t','split');
    % which columns in the line represent the features (11:436)?
    features(row_num, :) = str2double(a(1, 11:436));
    
    tline = fgets(fid);
    row_num = row_num + 1;
end

disp(['Features read from: ' features_file]);

dmat = eucliddist(features, clusters);
[bins, labels] = min(dmat,[],2);

n=num_of_clusters;
h=histc(labels,1:n);
my_histogram=transpose(h(:)/sqrt(h'*h));