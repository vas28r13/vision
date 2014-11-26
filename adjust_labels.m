function [] = adjust_labels(vids_dir, save_dir)


save_dir = [save_dir, '/'];

if(~exist(save_dir, 'dir'))
    mkdir(save_dir);
end

if (isdir(vids_dir))
    files = dir(vids_dir);
    file_dir = vids_dir;
end

for i = 1:length(files)
    file = files(i);
    if (strcmp(file.name, '.') || strcmp(file.name, '..') || strcmp(file.name, '.DS_Store'))
        continue;
    end
    full_path = [file_dir, '/', file.name];
    [directory, name, ext] = fileparts(full_path);
    
    name_array = regexp(name,'_','split');
    
    name = [name_array{1} '_' name_array{2} '_' num2str(str2double(name_array(3))+1) '_' name_array{4} ];
    
    movefile(full_path, [save_dir name ext]);
end