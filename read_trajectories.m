function [num_read] = read_trajectories(features_dir, save_dir, start)

% @param  -  features_dir  :  directory or file of features in txt format
% @param  -  save_dir      :  directory of where to save matlab files
% @param  -  start         :  the starting feature file in a directory (default : 1)

num_read = 0;

if (~exist('start','var'))
    start = 1;
end


save_dir = [save_dir, '/'];

if(~exist(save_dir, 'dir'))
    mkdir(save_dir);
end

if (isdir(features_dir))
    files = dir(features_dir);
    file_dir = features_dir;
else
    [file_dir, name, ext] = fileparts(features_dir);
    files(1) = struct('name', [name, ext]); 
end

features = [];
row_num = 1;

for i = start:length(files)
    file = files(i);
    if (strcmp(file.name, '.') || strcmp(file.name, '..') || strcmp(file.name, '.DS_Store'))
        continue;
    end
    full_path = [file_dir, '/', file.name];
    [directory, name, ext] = fileparts(full_path);
    disp(['Organizing features from: ', name, ext]);

    fid = fopen(full_path);
    tline = fgetl(fid);
    
    while ischar(tline)
        a = regexp(tline,'\t','split');
        features(row_num, :) = str2double(a(1,11:436));
        
        tline = fgets(fid);
        row_num = row_num + 1;
    end
    
    num_read = num_read + 1;
end

save([save_dir 'codebook1.mat'], 'features');