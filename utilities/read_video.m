function [ result ] = read_video(videoname, format)

% Enter the videoname and format of the video
%..only avi is supported at this time

if strcmp(format,'avi')
    str = sprintf('%s',videoname);
    %obj = mmreader(str);
    %video = read(obj);
    disp(str);
    obj=VideoReader(str);
    nframes = obj.NumberOfFrames;
    %obj=mmreader(sprintf('%s.avi',videoname));
    m=read(obj, [1 nframes-10]);
    if ndims(m) > 3
        m = squeeze(m(:,:,1,:));
    end
    test=(imshow(m(:,:,1)));
        disp('Press any button to continue...');
    pause;
    result=m;
end


