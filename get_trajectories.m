function [num_files] = get_trajectories(dense_dir, file_dir, save_dir, start)

% @param  -  dense_dir  :  the `dense trajectory` executable
% @param  -  file_dir   :  either the directory or directory + video file
% @param  -  save_dir   :  directory where to save these features
% @param  -  start      :  the starting vid number in a directory (default : 1)

num_files = 0;
save_dir = [save_dir, '/'];

if(~exist(save_dir, 'dir'))
    mkdir(save_dir);
end


if (isdir(file_dir))
    files = dir(file_dir);
else
    [file_dir, name, ext] = fileparts(file_dir);
    files(1) = struct('name', [name, ext]); 
end

for i = start:length(files)
    file = files(i);
    if (strcmp(file.name, '.') || strcmp(file.name, '..') || strcmp(file.name, '.DS_Store'))
        continue;
    end
    full_path = [file_dir, '/', file.name];
    [directory, name, ext] = fileparts(full_path);
    
    disp(['Running dense trajectory feature extraction on: ', name, ext]);
    command = [dense_dir, ' ', full_path, ' > ', save_dir, name, '.txt'];
    [status,cmdout] = unix(command);
    
    num_files = num_files + 1;
end