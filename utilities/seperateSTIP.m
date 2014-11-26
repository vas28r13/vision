function [ B ] = seperateSTIP(filename, vidname)

%Seperates the STIP .txt files that contain stips of numerous sequences

fid = fopen(filename, 'rt');

count = 1;
name = [vidname,num2str(count), '.txt'];
fide = fopen(name, 'w');

% loop until we find the end of the file
while ~feof(fid)
    
    str = fgetl(fid);
    fprintf(fide, '%s\n',str);
    
    if(length(str) < 5)
       count = count + 1;
       fclose(fide);
       name = [vidname,num2str(count), '.txt'];
       
       fide = fopen(name, 'w');
       disp('Saving');
    end
    B=str;
    
end

%close our buffers
fclose(fide);
fclose(fid);

end